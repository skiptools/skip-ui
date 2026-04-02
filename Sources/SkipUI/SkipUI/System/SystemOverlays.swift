// Copyright 2023–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if SKIP
import android.os.Build
import android.view.ViewTreeObserver
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsAnimationControlListenerCompat
import androidx.core.view.WindowInsetsAnimationControllerCompat
import androidx.core.view.WindowInsetsControllerCompat

private let statusBarInsetTypes: Int = 1 // WindowInsetsCompat.Type.STATUS_BARS

/*
Our goal here is to use a `WindowInsetsAnimationControllerCompat` (an `animationController`) to hide/show the status bar and/or the home indicator bar.

We're not just using `WindowInsetsControllerCompat` hide/show, because that uses a really ugly animation by default. (The status bar first fades to transparent for a full second, and then disappears, without animation, causing a layout shift).

We get an animation controller via `WindowInsetsControllerCompat.controlWindowInsetsAnimation`, in the `onReady` callback.

The system can choose to "cancel" our animation controller at any time, notifying us in an `onCancelled` callback. For example, our animation controller will be cancelled if the window loses focus (e.g. if you open the overview/recents app-switcher screen). When we regain focus, we have to re-hide the status bar.

If you call `controlWindowInsetsAnimation` "too early", it might call `onCancelled` instantly, or, worse, it might just never call you back at all. (The documentation says that you're supposed to use addOnControllableInsetsChangedListener and wait for that to call you back, but I found that it wasn't working. Even when I got the callback saying that the status bars are controllable, when I called `controlWindowInsetsAnimation` immediately afterward, I never got a callback.)

So: we attempt to request a controller ASAP during UIApplication.launch, but that probably won't succeed. Eventually, if the code calls `setStatusBarHidden`, _that_ will request a controller again, which normally succeeds.

We also listen for window focus changes on the window; if we just regained focus, we request a new controller and then reassert our preferred status bar state.
*/

class SkipUISystemOverlaysCoordinator: WindowInsetsAnimationControlListenerCompat, ViewTreeObserver.OnWindowFocusChangeListener {
    private var animationController: WindowInsetsAnimationControllerCompat?
    private var pendingStatusBarHidden = false
    
    private var activity: androidx.activity.ComponentActivity? { UIApplication.shared.androidActivity }
    private var viewTreeObserver: ViewTreeObserver? { activity?.window.decorView.viewTreeObserver }

    public func register() {
        if let viewTreeObserver, viewTreeObserver.isAlive {
            viewTreeObserver.addOnWindowFocusChangeListener(self)
        }
        requestAnimationController()
    }

    public func requestAnimationController() {
        guard Build.VERSION.SDK_INT >= 30, let activity else { return }
        activity.window.decorView.post {
            guard let activity, animationController?.isReady != true,
                  let decor = activity.window.decorView, decor.hasWindowFocus()
            else { return }
            let wicc = WindowCompat.getInsetsController(activity.window, decor)
            wicc.controlWindowInsetsAnimation(statusBarInsetTypes, -1, nil, nil, self)
        }
    }

    public func unregister() {
        if let viewTreeObserver {
            viewTreeObserver.removeOnWindowFocusChangeListener(self)
        }
        animationController?.finish(true)
        animationController = nil
        pendingStatusBarHidden = false
    }

    public func setStatusBarHidden(_ hidden: Bool) {
        pendingStatusBarHidden = hidden
        // API 30+ uses `WindowInsetsControllerCompat.controlWindowInsetsAnimation` when available; below 30 uses hide/show.
        if Build.VERSION.SDK_INT < 30 {
            guard let activity else { return }
            let wicc = WindowCompat.getInsetsController(activity.window, activity.window.decorView)
            if hidden {
                wicc.hide(statusBarInsetTypes)
            } else {
                wicc.show(statusBarInsetTypes)
            }
        } else {
            if animationController?.isReady == true {
                applyPendingInsets()
            } else {
                requestAnimationController()
            }
        }
    }

    private func applyPendingInsets() {
        guard let c = animationController, c.isReady else { return }
        let insets = pendingStatusBarHidden ? c.hiddenStateInsets : c.shownStateInsets
        c.setInsetsAndAlpha(insets, c.currentAlpha, Float(1.0))
    }

    override func onWindowFocusChanged(hasFocus: Bool) {
        guard hasFocus, let viewTreeObserver, viewTreeObserver.isAlive else { return }
        if Build.VERSION.SDK_INT < 30 {
            setStatusBarHidden(pendingStatusBarHidden)
        } else {
            requestAnimationController()
        }
    }

    override func onReady(controller: WindowInsetsAnimationControllerCompat, types: Int) {
        animationController = controller
        applyPendingInsets()
    }

    override func onFinished(controller: WindowInsetsAnimationControllerCompat) {}

    override func onCancelled(controller: WindowInsetsAnimationControllerCompat?) {
        animationController = nil
        requestAnimationController()
    }
}

#endif
