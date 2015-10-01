# Current as of 10.9
# Epic weird knot-tying happening here.
# TODO: clean up the process for generating this and include it

{ frameworks, libs, CF }:

with frameworks; with libs; {
  AGL                     = [ Carbon OpenGL ];
  AVFoundation            = [ ApplicationServices CoreGraphics ];
  AVKit                   = [];
  Accounts                = [];
  AddressBook             = [ Carbon CF ];
  AppKit                  = [ AudioToolbox QuartzCore ];
  AppKitScripting         = [];
  AppleScriptKit          = [];
  AppleScriptObjC         = [];
  AppleShareClientCore    = [ CoreServices ];
  AudioToolbox            = [ AudioUnit CoreAudio CF CoreMIDI ];
  AudioUnit               = [ Carbon CoreAudio CF ];
  AudioVideoBridging      = [ Foundation ];
  Automator               = [];
  CFNetwork               = [ CF ];
  CalendarStore           = [];
  Cocoa                   = [];
  Collaboration           = [];
  CoreAudio               = [ CF IOKit ];
  CoreAudioKit            = [ AudioUnit ];
  CoreData                = [];
  CoreGraphics            = [ Accelerate CF IOKit IOSurface SystemConfiguration ];
  CoreLocation            = [];
  CoreMIDI                = [ CF ];
  CoreMIDIServer          = [];
  CoreMedia               = [ ApplicationServices AudioToolbox CoreAudio CF CoreGraphics CoreVideo ];
  CoreMediaIO             = [ CF CoreMedia ];
  CoreText                = [ CF CoreGraphics ];
  CoreVideo               = [ ApplicationServices CF CoreGraphics IOSurface OpenGL ];
  CoreWLAN                = [ SecurityFoundation ];
  DVComponentGlue         = [ CoreServices QuickTime ];
  DVDPlayback             = [];
  DirectoryService        = [ CF ];
  DiscRecording           = [ CF CoreServices IOKit ];
  DiscRecordingUI         = [];
  DiskArbitration         = [ CF IOKit ];
  DrawSprocket            = [ Carbon ];
  EventKit                = [];
  ExceptionHandling       = [];
  FWAUserLib              = [];
  ForceFeedback           = [ CF IOKit ];
  Foundation              = [ CF Security ApplicationServices AppKit SystemConfiguration ];
  GLKit                   = [ CF ];
  GLUT                    = [ GL OpenGL ];
  GSS                     = [];
  GameController          = [];
  GameKit                 = [ Foundation ];
  ICADevices              = [ Carbon CF IOBluetooth ];
  IMServicePlugIn         = [];
  IOBluetoothUI           = [ IOBluetooth ];
  IOKit                   = [ CF ];
  IOSurface               = [ CF IOKit xpc ];
  ImageCaptureCore        = [];
  ImageIO                 = [ CF CoreGraphics ];
  InputMethodKit          = [ Carbon ];
  InstallerPlugins        = [];
  InstantMessage          = [];
  JavaFrameEmbedding      = [];
  JavaScriptCore          = [ CF ];
  Kerberos                = [];
  Kernel                  = [ CF IOKit ];
  LDAP                    = [];
  LatentSemanticMapping   = [ Carbon CF ];
  MapKit                  = [];
  MediaAccessibility      = [ CF CoreGraphics CoreText QuartzCore ];
  MediaToolbox            = [ AudioToolbox CF CoreMedia ];
  NetFS                   = [ CF ];
  OSAKit                  = [ Carbon ];
  OpenAL                  = [];
  OpenCL                  = [ IOSurface OpenGL ];
  OpenGL                  = [];
  PCSC                    = [ CoreData ];
  PreferencePanes         = [];
  PubSub                  = [];
  Python                  = [ ApplicationServices ];
  QTKit                   = [ CoreMediaIO CoreMedia MediaToolbox QuickTime VideoToolbox ];
  QuickLook               = [ ApplicationServices CF ];
  QuickTime               = [ ApplicationServices AudioUnit Carbon CoreAudio CoreServices OpenGL QuartzCore ];
  Ruby                    = [];
  RubyCocoa               = [];
  SceneKit                = [];
  ScreenSaver             = [];
  Scripting               = [];
  ScriptingBridge         = [];
  Security                = [ CF IOKit ];
  SecurityFoundation      = [];
  SecurityInterface       = [ Security ];
  ServiceManagement       = [ CF Security ];
  Social                  = [];
  SpriteKit               = [];
  StoreKit                = [];
  SyncServices            = [];
  SystemConfiguration     = [ CF Security ];
  TWAIN                   = [ Carbon ];
  Tcl                     = [];
  Tk                      = [ ApplicationServices Carbon X11 ];
  VideoDecodeAcceleration = [ CF CoreVideo ];
  VideoToolbox            = [ CF CoreMedia CoreVideo ];
  WebKit                  = [ ApplicationServices Carbon JavaScriptCore OpenGL ];

  # Umbrellas
  Accelerate          = [ CoreWLAN IOBluetooth ];
  ApplicationServices = [ CF CoreServices CoreText ImageIO ];
  Carbon              = [ ApplicationServices CF CoreServices IOKit Security QuartzCore ];
  CoreBluetooth       = [];
  CoreServices        = [ CFNetwork CoreAudio CoreData CF DiskArbitration Security NetFS OpenDirectory ServiceManagement ];
  IOBluetooth         = [ IOKit ];
  JavaVM              = [];
  OpenDirectory       = [];
  Quartz              = [ QuickLook QTKit ];
  QuartzCore          = [ ApplicationServices CF CoreVideo OpenCL ];
}
