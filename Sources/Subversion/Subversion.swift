//
// Subversion.swift
//
// Created by Park, Sangpyo (2018년 2월)
//

import Foundation
import SwiftShell


public enum Subcommand: String {
    case checkout = "checkout"
    case add
    case commit
    case cat
    case info
    case update
    case log
    case diff
    case list
    case cleanup
}

public typealias svn = Subversion

public struct Subversion {
    
    var globalOptions: [String: Any] = [
        "--username": "",
        "--password": "",
        "--no-auth-cache": "",
        "--non-interactive": "",
        "--trust-server-cert": "",
        "--config-option": "servers:global:http-auth-types=basic",
    ]

    var authentictionParameters: [String] {
        return Array(globalOptions.map{ args -> [String] in
                let (key, value) = args
                if let value = value as? String, value.isEmpty {
                  return [key] 
                } else {
                    return [key, "\(value)"]
            }
        }.reversed().joined())
    }
    
    public init(withUsername username: String, andPassword password: String) {
        
        globalOptions["--username"] = username
        globalOptions["--password"] = password
    }
    
    public func svn(withSubcommand subcommand: Subcommand, andArguments arguments: Any) -> String {
        
        var options: [Any] = [""]
        
        if let arguments = arguments as? [String: Any] {
            options = Array(arguments.map{ args -> [String] in
                let (key, value) = args
                if let value = value as? String, value.isEmpty {
                    return [key] 
                } else if let value = value as? [String] {
                    return [key] + value
                } else {
                    return [key, "\(value)"]
                }
            }.reversed().joined())
        } else if let arguments = arguments as? [Any] {
            options = arguments
        } else  {
            options.append(arguments)   
        }

//        print("options: \(options)")
        let result = run("svn", subcommand, authentictionParameters, options)
        return result.succeeded ? result.stdout : result.stderror
    }

    public func checkout(from url: URL, destinationPath path: String? = nil, revision rev: Any? = nil) -> String {
        
        var arguments: [String: Any] = [url.absoluteString: ""]
        
        if let path = path {
            arguments[path] = ""
        }
        if let rev = rev {
            arguments["--revision"] = rev
        }
        
        return svn(withSubcommand: .checkout, andArguments: arguments)
    }
   
    public func commit(workingCopyPath path: [String], withMessage message: String) -> String {
                                      
        var options: [String] = ["--force-log", "--message", message]
        options.append(contentsOf: path)
        return svn(withSubcommand: .commit, andArguments: options)
    }
    
    public func add(workingCopyPath path: String) -> String {
            
        let options: [String] = ["--force", path]
        return svn(withSubcommand: .add, andArguments: options)
    }
    
    public func cat(workingCopyPath path: String, revision rev: Any? = nil) -> String {
        var options: [String: Any] = [path: ""]
        
        if let rev = rev {
            options["--revision"] = rev
        }
        
        return svn(withSubcommand: .cat, andArguments: options)
    }
    
    public func info(workingCopyPath path: String, revision rev: Any? = nil) -> String {
        var options: [String: Any] = [path: ""]
        
        if let rev = rev {
            options["--revision"] = rev
        }
        
        return svn(withSubcommand: .info, andArguments: options)
    }
    
    public func log(workingCopyPath path: [String], revision rev: Any? = nil) -> String {
        var options: [String] = ["--xml"]
        
        if let rev = rev {
            options.append("--revision")
            options.append("\(rev)")
        }
        
        options.append(contentsOf: path)
        
        return svn(withSubcommand: .log, andArguments: options)
    }
    
    public func update(workingCopyPath path: [String], revision rev: Any? = nil) -> String {
        var options: [String] = [""]
        
        if let rev = rev {
            options.append("--revision")
            options.append("\(rev)")
        }
        
        options.append(contentsOf: path)
        
        return svn(withSubcommand: .update, andArguments: options)
    }
    
    public func diff(target path: String, summarizedResult summarize: Bool,  oldRevision oldRev: Any, newRevision newRev: Any? = nil) -> String {
        
        var options: [String: Any] = ["--git": ""]
        
        let oldTarget = path + "@" + "\(oldRev)"
        var newTarget = path
        if let newRev = newRev {
            newTarget += "@" + "\(newRev)"
        }
        
        options["--old"] = oldTarget
        options["--new"] = newTarget
        
        if summarize == true {
            options["--summarize"] = ""
        }
        
        return svn(withSubcommand: .diff, andArguments: options)
    }
   
    public func list(target pathOrUrl: String) -> String {
        let options: [String] = [pathOrUrl]
        return svn(withSubcommand: .list, andArguments: options)
    }
    
    public func cleanup(workingCopyPath path: String) -> String {
        let options: [String] = [path]
        return svn(withSubcommand: .cleanup, andArguments: options)
    }
}

//let subversion = Subversion(withUsername: "myid", andPassword: "****")

//let url = URL(string: "https://svn.myserver.com/Project/MyProject")

//let result = subversion.checkout(from: url!)
//let result = subversion.checkout(from: url!, destinationPath: nil, revision: nil)
//let result = subversion.checkout(from: url!, destinationPath: "Src", revision: 350_994)

//let result = subversion.add(workingCopyPath:"./Doc/Readme.txt")
//let result = subversion.add(workingCopyPath:"./Doc/Readme.md")

//let result = subversion.commit(workingCopyPath: ["./Doc/Readme.txt", "./Doc/Readme.md"], withMessage: "This a readme file.")

//let result = subversion.cat(workingCopyPath:"./Doc/Readme.md", revision: 52983)

//let result = subversion.info(workingCopyPath:"./Doc/Readme.md")

//let result = subversion.log(workingCopyPath:"./Doc/Readme.md")

//let result = subversion.update(workingCopyPath: ["./Doc/Readme.md", "./Doc/Readme.txt"])

//let result = subversion.diff(target: "./Doc", summarizedResult: true, oldRevision: 52982, newRevision: 52983)
//let result = subversion.diff(target: "./Doc", summarizedResult: true, oldRevision: 52982)
//let result = subversion.diff(target: "./Doc", summarizedResult: false, oldRevision: 52982)

//let result = subversion.list(target: "https://svn.myserver.com/Project/MyProject")
//let result = subversion.list(target: "./Doc")

//print("result:\n-----\n\(result)")

