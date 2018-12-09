import ./make-test.nix ({ pkgs, ... }:

let
  passphrase = "supersecret";
  dataDir = "/ran:dom/data";
  excludeFile = "not_this_file";
  keepFile = "important_file";
  keepFileData = "important_data";
  localRepo = "/root/back:up";
  archiveName = "my_archive";
  remoteRepo = "borg@server:."; # No need to specify path
  privateKey = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrwAAAJB+cF5HfnBe
    RwAAAAtzc2gtZWQyNTUxOQAAACBx8UB04Q6Q/fwDFjakHq904PYFzG9pU2TJ9KXpaPMcrw
    AAAEBN75NsJZSpt63faCuaD75Unko0JjlSDxMhYHAPJk2/xXHxQHThDpD9/AMWNqQer3Tg
    9gXMb2lTZMn0pelo8xyvAAAADXJzY2h1ZXR6QGt1cnQ=
    -----END OPENSSH PRIVATE KEY-----
  '';
  publicKey = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHHxQHThDpD9/AMWNqQer3Tg9gXMb2lTZMn0pelo8xyv root@client
  '';
  privateKeyAppendOnly = pkgs.writeText "id_ed25519" ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACBacZuz1ELGQdhI7PF6dGFafCDlvh8pSEc4cHjkW0QjLwAAAJC9YTxxvWE8
    cQAAAAtzc2gtZWQyNTUxOQAAACBacZuz1ELGQdhI7PF6dGFafCDlvh8pSEc4cHjkW0QjLw
    AAAEAAhV7wTl5dL/lz+PF/d4PnZXuG1Id6L/mFEiGT1tZsuFpxm7PUQsZB2Ejs8Xp0YVp8
    IOW+HylIRzhweORbRCMvAAAADXJzY2h1ZXR6QGt1cnQ=
    -----END OPENSSH PRIVATE KEY-----
  '';
  publicKeyAppendOnly = ''
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFpxm7PUQsZB2Ejs8Xp0YVp8IOW+HylIRzhweORbRCMv root@client
  '';

in {
  name = "borgbackup";
  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ dotlambda ];
  };

  nodes = {
    client = { ... }: {
      services.borgbackup.jobs = {
        
        local = rec {
          paths = dataDir;
          repo = localRepo;
          preHook = ''
            # Don't append a timestamp
            archiveName="${archiveName}"
          '';
          encryption = {
            mode = "repokey";
            inherit passphrase;
          };
          compression = "auto,zlib,9";
          prune.keep = {
            within = "1y";
            yearly = 5;
          };
          exclude = [ "*/${excludeFile}" ];
          postHook = "echo post";
          startAt = [ ]; # Do not run automatically
        };

        remote = {
          paths = dataDir;
          repo = remoteRepo;
          encryption.mode = "none";
          startAt = [ ];
          environment.BORG_RSH = "ssh -oStrictHostKeyChecking=no -i /root/id_ed25519";
        };

        remoteAppendOnly = {
          paths = dataDir;
          repo = remoteRepo;
          encryption.mode = "none";
          startAt = [ ];
          environment.BORG_RSH = "ssh -oStrictHostKeyChecking=no -i /root/id_ed25519.appendOnly";
        };

      };
    };

    server = { ... }: {
      services.openssh = {
        enable = true;
        passwordAuthentication = false;
        challengeResponseAuthentication = false;
      };

      services.borgbackup.repos.repo1 = {
        authorizedKeys = [ publicKey ];
        path = "/data/borgbackup";
      };

      # Second repo to make sure the authorizedKeys options are merged correctly
      services.borgbackup.repos.repo2 = {
        authorizedKeysAppendOnly = [ publicKeyAppendOnly ];
        path = "/data/borgbackup";
        quota = ".5G";
      };
    };
  };

  testScript = ''
    startAll;

    $client->fail('test -d "${remoteRepo}"');

    $client->succeed("cp ${privateKey} /root/id_ed25519");
    $client->succeed("chmod 0600 /root/id_ed25519");
    $client->succeed("cp ${privateKeyAppendOnly} /root/id_ed25519.appendOnly");
    $client->succeed("chmod 0600 /root/id_ed25519.appendOnly");

    $client->succeed("mkdir -p ${dataDir}");
    $client->succeed("touch ${dataDir}/${excludeFile}");
    $client->succeed("echo '${keepFileData}' > ${dataDir}/${keepFile}");

    subtest "local", sub {
      my $borg = "BORG_PASSPHRASE='${passphrase}' borg";
      $client->systemctl("start --wait borgbackup-job-local");
      $client->fail("systemctl is-failed borgbackup-job-local");
      # Make sure exactly one archive has been created
      $client->succeed("c=\$($borg list '${localRepo}' | wc -l) && [[ \$c == '1' ]]");
      # Make sure excludeFile has been excluded
      $client->fail("$borg list '${localRepo}::${archiveName}' | grep -qF '${excludeFile}'");
      # Make sure keepFile has the correct content
      $client->succeed("$borg extract '${localRepo}::${archiveName}'");
      $client->succeed('c=$(cat ${dataDir}/${keepFile}) && [[ "$c" == "${keepFileData}" ]]');
      # Make sure the same is true when using `borg mount`
      $client->succeed("mkdir -p /mnt/borg && $borg mount '${localRepo}::${archiveName}' /mnt/borg");
      $client->succeed('c=$(cat /mnt/borg/${dataDir}/${keepFile}) && [[ "$c" == "${keepFileData}" ]]');
    };

    subtest "remote", sub {
      my $borg = "BORG_RSH='ssh -oStrictHostKeyChecking=no -i /root/id_ed25519' borg";
      $server->waitForUnit("sshd.service");
      $client->waitForUnit("network.target");
      $client->systemctl("start --wait borgbackup-job-remote");
      $client->fail("systemctl is-failed borgbackup-job-remote");

      # Make sure we can't access repos other than the specified one
      $client->fail("$borg list borg\@server:wrong");

      #TODO: Make sure that data is actually deleted
    };

    subtest "remoteAppendOnly", sub {
      my $borg = "BORG_RSH='ssh -oStrictHostKeyChecking=no -i /root/id_ed25519.appendOnly' borg";
      $server->waitForUnit("sshd.service");
      $client->waitForUnit("network.target");
      $client->systemctl("start --wait borgbackup-job-remoteAppendOnly");
      $client->fail("systemctl is-failed borgbackup-job-remoteAppendOnly");

      # Make sure we can't access repos other than the specified one
      $client->fail("$borg list borg\@server:wrong");

      #TODO: Make sure that data is not actually deleted
    };

  '';
})
