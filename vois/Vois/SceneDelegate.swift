//
//  SceneDelegate.swift
//  Vois
//
//  Created by Jiang Yuxin on 14/3/20.
//  Copyright © 2020 Vois. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to
        // the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized
        // and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see
        // `application:configurationForConnectingSceneSession` instead).
        if scene as? UIWindowScene == nil {
            return
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session
        // is discarded.
        // Release any resources associated with this scene that can be re-created the
        // next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded
        // (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func startReviewing(recording: Recording) {
        guard let audioPlaybackVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(identifier: "AudioPlaybackController") as? AudioPlaybackController else {
            return
        }
        audioPlaybackVC.recording = recording
        audioPlaybackVC.recordingList = [recording]

        guard let splitVC = window?.rootViewController as? UISplitViewController else {
            return
        }
        splitVC.present(audioPlaybackVC, animated: false)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }

        guard let user = parameters["creater"],
            let recordingId = parameters["recording"] else {
                return
        }

        guard let reviewer = UserSession.user else {
            return
        }

        let cloudStorage = CloudStorage()
        let storageObserverDelegate = ReviewingStorageDelegate(reviewer: reviewer, cloudStorage: cloudStorage)
        cloudStorage.setupForReviewing {
            cloudStorage.read(reference: recordingId) { data in
                guard let recording = RecordingReview(dictionary: data, uid: recordingId,
                                                      storageObserverDelegate: cloudStorage) else {
                    return
                }
                recording.storageObserverDelegate = storageObserverDelegate
                recording.updateRecording {
                    self.startReviewing(recording: recording)
                }
            }
        }
    }

}
