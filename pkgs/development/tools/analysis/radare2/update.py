#!/usr/bin/env nix-shell
#!nix-shell -p nix -p python3 -p git -i python
# USAGE - just run the script: ./update.py
# When editing this file, make also sure it passes the mypy typecheck
# and is formatted with black.
import fileinput
import json
import re
import subprocess
import tempfile
import urllib.request
from datetime import datetime
from pathlib import Path
from typing import Dict


def sh(*args: str) -> str:
    out = subprocess.check_output(list(args))
    return out.strip().decode("utf-8")


def prefetch_github(owner: str, repo: str, ref: str) -> str:
    return sh(
        "nix-prefetch-url",
        "--unpack",
        f"https://github.com/{owner}/{repo}/archive/{ref}.tar.gz",
    )


def get_radare2_rev() -> str:
    url = "https://api.github.com/repos/radare/radare2/releases/latest"
    with urllib.request.urlopen(url) as response:
        release = json.load(response)  # type: ignore
    return release["tag_name"]


def get_r2_cutter_rev() -> str:
    url = "https://api.github.com/repos/radareorg/cutter/contents/"
    with urllib.request.urlopen(url) as response:
        data = json.load(response)  # type: ignore
    for entry in data:
        if entry["name"] == "radare2":
            return entry["sha"]
    raise Exception("no radare2 submodule found in github.com/radareorg/cutter")


def git(dirname: str, *args: str) -> str:
    return sh("git", "-C", dirname, *args)


def get_repo_info(dirname: str, rev: str) -> Dict[str, str]:
    sha256 = prefetch_github("radare", "radare2", rev)

    cs_tip = None
    with open(Path(dirname).joinpath("shlr", "Makefile")) as makefile:
        for l in makefile:
            match = re.match("CS_TIP=(\S+)", l)
            if match:
                cs_tip = match.group(1)
    assert cs_tip is not None

    cs_sha256 = prefetch_github("aquynh", "capstone", cs_tip)

    return dict(
        rev=rev,
        sha256=sha256,
        version_commit=git(dirname, "rev-list", "--all", "--count"),
        gittap=git(dirname, "describe", "--tags", "--match", "[0-9]*"),
        gittip=git(dirname, "rev-parse", "HEAD"),
        cs_tip=cs_tip,
        cs_sha256=cs_sha256,
    )


def write_package_expr(version: str, info: Dict[str, str]) -> str:
    return f"""generic {{
    version_commit = "{info["version_commit"]}";
    gittap = "{info["gittap"]}";
    gittip = "{info["gittip"]}";
    rev = "{info["rev"]}";
    version = "{version}";
    sha256 = "{info["sha256"]}";
    cs_tip = "{info["cs_tip"]}";
    cs_sha256 = "{info["cs_sha256"]}";
  }}"""


def main() -> None:
    radare2_rev = get_radare2_rev()
    r2_cutter_rev = get_r2_cutter_rev()

    with tempfile.TemporaryDirectory() as dirname:
        git(
            dirname,
            "clone",
            "--branch",
            radare2_rev,
            "https://github.com/radare/radare2",
            ".",
        )
        nix_file = str(Path(__file__).parent.joinpath("default.nix"))

        radare2_info = get_repo_info(dirname, radare2_rev)

        git(dirname, "checkout", r2_cutter_rev)

        timestamp = git(dirname, "log", "-n1", "--format=%at")
        r2_cutter_version = datetime.fromtimestamp(int(timestamp)).strftime("%Y-%m-%d")

        r2_cutter_info = get_repo_info(dirname, r2_cutter_rev)

        in_block = False
        with fileinput.FileInput(nix_file, inplace=True) as f:
            for l in f:
                if "#<generated>" in l:
                    in_block = True
                    print(
                        f"""  #<generated>
  # DO NOT EDIT! Automatically generated by ./update.py
  radare2 = {write_package_expr(radare2_rev, radare2_info)};
  r2-for-cutter = {write_package_expr(r2_cutter_version, r2_cutter_info)};
  #</generated>"""
                    )
                elif "#</generated>" in l:
                    in_block = False
                elif not in_block:
                    print(l, end="")


if __name__ == "__main__":
    main()
