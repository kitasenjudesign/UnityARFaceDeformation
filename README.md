# Unity-ARKit-Plugin #

[**Latest Update:** This plugin now supports new ARKit functionality exposed in ARKit 1.5 update.  See this [blog post](https://blogs.unity3d.com/2018/02/16/developing-for-arkit-1-5-update-using-unity-arkit-plugin/) for details.]

This is a native [Unity](https://unity3d.com/) plugin that exposes the functionality of Apple’s
[ARKit SDK](https://developer.apple.com/arkit/) to your Unity projects for compatible iOS devices.  Includes ARKit features such as world tracking, pass-through camera rendering, horizontal and vertical plane detection and
update, face tracking (requires iPhone X), image anchors, point cloud extraction, light estimation, and hit testing API to Unity developers for their AR projects. This plugin is a _preview quality_ build that
will help you get up and running quickly, but the implementation and APIs are subject to change.  Nevertheless, it is quite capable of creating a full featured ARKit app, and hundreds of ARKit apps on the AppStore already use this plugin.

Please read [LICENSE](./LICENSE) for licensing information.

The code drop is a Unity project, compatible with Unity 2017.1 and later. It contains the plugin sources, example scenes, and components that you may use in your own projects.  See [TUTORIAL.txt](./TUTORIAL.txt) for detailed setup instructions.

Please feel free to extend the plugin and send pull requests. You may also provide feedback if you would like improvements or want to suggest changes.  Happy coding and have fun!


## Requirements: ##
* [Unity](https://unity3d.com/get-unity/download) v2017.1+
* Apple [Xcode](https://developer.apple.com/xcode/) 9.3+ with latest iOS SDK that contains ARKit Framework
* Apple iOS device that supports ARKit (iPhone 6S or later, iPad (2017) or later)
* Apple [iOS 11.3](https://www.apple.com/ios/ios-11/)+ installed on device

## Building ##

Give it a go yourself. Open up 
[UnityARKitScene.unity](./Assets/UnityARKitPlugin/Examples/UnityARKitScene/UnityARKitScene.unity) 
— a scene that demostrates ARKit’s basic functionality —
and try building it to iOS.
Note that 
[UnityARBuildPostprocessor.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Editor/UnityARBuildPostprocessor.cs)
is an editor script that executes at build time, and does some modifications to the XCode project that is exported by Unity.  You could also try building the other example scenes in the subfolders of the [Examples](./Assets/UnityARKitPlugin/Examples/) folder.  
 

## API overview ##


[UnityARSessionNativeInterface.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/NativeInterface/UnityARSessionNativeInterface.cs) 
implements the following:

```CSharp
public void RunWithConfigAndOptions( ARKitWorldTackingSessionConfiguration config, UnityARSessionRunOption runOptions )
public void RunWithConfig( ARKitWorldTackingSessionConfiguration config )
public void Pause()
public List<ARHitTestResult> HitTest( ARPoint point, ARHitTestResultType types )
public ARTextureHandles GetARVideoTextureHandles()
public float GetARAmbientIntensity()
public int GetARTrackingQuality() 
```
	    


  
It also contains events that you can provide these delegates for: 

```CSharp
public delegate void ARFrameUpdate( UnityARCamera camera )

public delegate void ARAnchorAdded( ARPlaneAnchor anchorData )
public delegate void ARAnchorUpdated( ARPlaneAnchor anchorData )
public delegate void ARAnchorRemoved( ARPlaneAnchor anchorData )

public delegate void ARUserAnchorAdded(ARUserAnchor anchorData)
public delegate void ARUserAnchorUpdated(ARUserAnchor anchorData)
public delegate void ARUserAnchorRemoved(ARUserAnchor anchorData)

public delegate void ARFaceAnchorAdded(ARFaceAnchor anchorData)
public delegate void ARFaceAnchorUpdated(ARFaceAnchor anchorData)
public delegate void ARFaceAnchorRemoved(ARFaceAnchor anchorData)

public delegate void ARImageAnchorAdded(ARImageAnchor anchorData)
public delegate void ARImageAnchorUpdated(ARImageAnchor anchorData)
public delegate void ARImageAnchorRemoved(ARImageAnchor anchorData)

public delegate void ARSessionFailed( string error )
public delegate void ARSessionCallback();
public delegate void ARSessionTrackingChanged(UnityARCamera camera)

```

These are the list of events you can subscribe to:

```CSharp
public static event ARFrameUpdate ARFrameUpdatedEvent;

public static event ARAnchorAdded ARAnchorAddedEvent;
public static event ARAnchorUpdated ARAnchorUpdatedEvent;
public static event ARAnchorRemoved ARAnchorRemovedEvent;

public static event ARUserAnchorAdded ARUserAnchorAddedEvent;
public static event ARUserAnchorUpdated ARUserAnchorUpdatedEvent;
public static event ARUserAnchorRemoved ARUserAnchorRemovedEvent;

public static event ARFaceAnchorAdded ARFaceAnchorAddedEvent;
public static event ARFaceAnchorUpdated ARFaceAnchorUpdatedEvent;
public static event ARFaceAnchorRemoved ARFaceAnchorRemovedEvent;

public static event ARImageAnchorAdded ARImageAnchorAddedEvent;
public static event ARImageAnchorUpdated ARImageAnchorUpdatedEvent;
public static event ARImageAnchorRemoved ARImageAnchorRemovedEvent;

public static event ARSessionFailed ARSessionFailedEvent;
public static event ARSessionCallback ARSessionInterruptedEvent;
public static event ARSessionCallback ARSessioninterruptionEndedEvent;
public static event ARSessionTrackingChanged ARSessionTrackingChangedEvent;
```
  
[ARSessionNative.mm](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/NativeInterface/ARSessionNative.mm) contains Objective-C code for directly interfacing with the ARKit SDK.

All C# files in the [NativeInterface](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/NativeInterface/) folder beginning with “AR” are the scripting API equivalents of data structures exposed by ARKit.


## ARKit useful components ##

**Physical camera feed**. Place this component on the physcial camera object. It will grab the textures needed for rendering the video, set it on the material needed for blitting to the backbuffer, and set up the command buffer to do the actual blit.
[UnityARVideo.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/UnityARVideo.cs)

**Virtual camera manager**. Place this component on a GameObject in the scene that references the virtual camera that you intend to control via ARKit.
It will position and rotate the camera as well as provide the correct projection matrix to it based on updates from ARKit.
This component also has the code to initialize an ARKit session.
[UnityARCameraManager.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/UnityARCameraManager.cs)

**Plane anchor GameObjects**. For each plane anchor detected, this component generates a GameObject which is instantiated from a referenced prefab and positioned, scaled and rotated according to plane detected. As the plane anchor updates and is removed, so is the corresponding GameObject. [UnityARGeneratePlane.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/UnityARGeneratePlane.cs)

**Point cloud visualizer**. This component references a particle system prefab, maximum number of particles and size per particle to be able to visualize the point cloud as particles in space. [PointCloudParticleExample.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/PointCloudParticleExample.cs)

**Hit test**. This component references the root transform of a GameObject in the scene, and does an ARKit Hit Test against the scene wherever user touches on screen, and when hit successful (against HitTest result types enumerated in the script), moves the referenced GameObject to that hit point. [UnityARHitTestExample.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/UnityARHitTestExample.cs)

**Light estimation**. This component when added to a light in the scene will scale the intensity of that light to the estimated lighting in the real scene being viewed. [UnityARAmbient.cs](./Assets/UnityARKitPlugin/Plugins/iOS/UnityARKit/Helpers/UnityARAmbient.cs)

You can read how some of these components are used in the [Examples](./Assets/UnityARKitPlugin/Examples/) scenes by checking out [SCENES.txt](./SCENES.txt).


## Feature documentation ##

As newer features have been added on to the plugin, they have been documented in detail elsewhere.  Here are links to those documents:

### Unity ARKit Remote ###

[“Introducing the Unity ARKit Remote”](https://blogs.unity3d.com/2017/08/03/introducing-the-unity-arkit-remote/)

[“ARKit Remote: Now with face tracking!"](https://blogs.unity3d.com/2018/01/16/arkit-remote-now-with-face-tracking/)


### Face tracking ###

[“ARKit Face Tracking on iPhone X.”](https://blogs.unity3d.com/2017/11/03/arkit-face-tracking-on-iphone-x/)
(Yes—It requires an [iPhone X](https://www.apple.com/iphone-x/).)

["Create your own animated emojis with Unity!"](https://blogs.unity3d.com/2017/12/03/create-your-own-animated-emojis-with-unity/)

### Plugin Settings file ###

["ARKit uses Face Tracking API"](https://forum.unity.com/threads/submitting-arkit-apps-to-appstore-without-face-tracking.504572/#post-3297235)

["App requires ARKit device"](https://forum.unity.com/threads/arkit-support-for-ios-via-unity-arkit-plugin.474385/page-43#post-3297582)

### ARKit 1.5 Update ###

Unity blog post ["Developing for ARKit 1.5 update using Unity ARKit Plugin"](https://blogs.unity3d.com/2018/02/16/developing-for-arkit-1-5-update-using-unity-arkit-plugin/)


## Questions?  Bugs? Showcase? ##

Contact us via the [forums](https://forum.unity.com/forums/arkit-preview.139/) for questions.

You may submit [issues](https://bitbucket.org/Unity-Technologies/unity-arkit-plugin/issues?status=new&status=open) if you feel there are bugs that are not solved by asking on the forums.

You may submit a [pull request](https://bitbucket.org/Unity-Technologies/unity-arkit-plugin/pull-requests/) if you believe you have a useful enhancement for this plugin.

Follow [@jimmyjamjam](https://twitter.com/jimmy_jam_jam) for various AR related tweets, and showcase your creation there as well.