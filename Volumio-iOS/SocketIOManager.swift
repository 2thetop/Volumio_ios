//
//  SocketIOManager.swift
//  Volumio-iOS
//
//  Created by Federico Sintucci on 21/09/16.
//  Copyright © 2016 Federico Sintucci. All rights reserved.
//

import UIKit
import SocketIO
import ObjectMapper

class SocketIOManager: NSObject {
    
    static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://volumio.local:3000")!)
    
    var currentTrack : CurrentTrack?
    var currentPlaylist : [CurrentTrack]?
    var currentSources : [[String:Any]]?
    
    func establishConnection() {
        socket.connect()
        socket.on("connect") { data, ack in
            self.socket.emit("getState")
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func playTrack(position:Int) {
        socket.emit("play", position)
    }
    
    func setPlayback(status:String) {
        socket.emit(status)
    }
    
    func nextTrack() {
        socket.emit("next")
    }
    
    func prevTrack() {
        socket.emit("prev")
    }
    
    func setVolume(value:Int) {
        socket.emit("volume", value)
    }
    
    func getState() {
        socket.on("pushState") {data, ack in
            if let json = data[0] as? [String : Any] {
                self.currentTrack = Mapper<CurrentTrack>().map(JSONObject: json)
            }
            NotificationCenter.default.post(name: NSNotification.Name("currentTrack"), object: self.currentTrack)
        }
        
//        socket.onAny {
//            print("Got event: \($0.event), with items: \($0.items)")
//        }
    }
    
    func browseSources() {
        self.socket.emit("getBrowseSources")
        socket.on("pushBrowseSources") {data, ack in
            if let json = data[0] as? [[String : Any]] {
                self.currentSources = json
            }
        }
    }
    
    func browseLibrary(uri:String) {
//        socket.emit("getBrowseLibrary", ["uri":uri])
    }
    
    func getQueue() {
        self.socket.emit("getQueue")
        socket.on("pushQueue") {data, ack in
            if let json = data[0] as? [[String:Any]] {
                self.currentPlaylist = Mapper<CurrentTrack>().mapArray(JSONObject: json)!
            }
            NotificationCenter.default.post(name: NSNotification.Name("currentPlaylist"), object: nil)
        }
    }
    
    func removeFromQueue(position:Int) {
        self.socket.emit("removeFromQueue", position)
        self.getQueue()
    }
    
}
 
