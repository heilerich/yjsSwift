//
//  JSTimer.swift
//  
//
//  Created by Felix Heilmeyer on 24.09.20.
//
import JavaScriptCore

@objc protocol JSTimerExport : JSExport {
    func setTimeout(_ callback : JSValue,_ ms : Double) -> String
    func clearTimeout(_ identifier: String)
    func setInterval(_ callback : JSValue,_ ms : Double) -> String
}

@objc class JSTimer: NSObject, JSTimerExport {
    static let shared = JSTimer()
    
    var timers = [String: Timer]()
    
    let queue = DispatchQueue(label: "jstimers")

    static func registerInto(jsContext: JSContext) {
        jsContext.setObject(shared, forKeyedSubscript: "timerJS" as (NSCopying & NSObjectProtocol))
        jsContext.evaluateScript(
        """
        function setTimeout(callback, ms) {
            return timerJS.setTimeout(callback, ms)
        }
        function clearTimeout(identifier) {
            timerJS.clearTimeout(identifier)
        }
        function setInterval(callback, ms) {
            return timerJS.setInterval(callback, ms)
        }
        function clearInterval(identifier) {
            timerJS.clearTimeout(identifier)
        }
        """
        )
    }

    func clearTimeout(_ identifier: String) {
        queue.sync {
            let timer = timers.removeValue(forKey: identifier)
            timer?.invalidate()
        }
    }

    func setInterval(_ callback: JSValue,_ ms: Double) -> String {
        return createTimer(callback: callback, ms: ms, repeats: true)
    }

    func setTimeout(_ callback: JSValue, _ ms: Double) -> String {
        return createTimer(callback: callback, ms: ms , repeats: false)
    }

    func createTimer(callback: JSValue, ms: Double, repeats : Bool) -> String {
        let timeInterval  = ms/1000.0
        let uuid = UUID().uuidString
        queue.sync {
            let timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                             target: self,
                                             selector: #selector(self.callJsCallback),
                                             userInfo: callback,
                                             repeats: repeats)
            self.timers[uuid] = timer
        }
        return uuid
    }

    @objc func callJsCallback(_ timer: Timer) {
        queue.sync {
            let callback = (timer.userInfo as! JSValue)
            callback.call(withArguments: nil)
        }
    }
}
