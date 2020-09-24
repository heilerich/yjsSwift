//
//  YCore.swift
//  
//
//  Created by Felix Heilmeyer on 24.09.20.
//

import os.log
import JavaScriptCore

struct YCore {
    static let shared = YCore()
    
    let context: JSContext
    
    init() {
        let queue = DispatchQueue.global(qos: .background)
        let vm = queue.sync { JSVirtualMachine() }
        context = JSContext(virtualMachine: vm)
                
        context.exceptionHandler = { context, exception in
            os_log("Exception in JSContext: %{private}@", log: .javascript, type: .error, exception?.toString() ?? "(nil)")
        }
        
        JSTimer.registerInto(jsContext: context)
        
        guard let url = Bundle.module.url(forResource: "yjs", withExtension: "js") else {
            fatalError("could not find yjs.js resource")
        }
        do {
            context.evaluateScript(try String(contentsOf: url), withSourceURL: url)
        } catch {
            fatalError("could not load yjs: \(error)")
        }
    }
}
