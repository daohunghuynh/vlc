//
//  Helpers.swift
//  Pixie
//
//  Created by Dao Hung Huynh on 17/03/2018.
//  Copyright © 2018 Dao Hung Huynh. All rights reserved.
//
import AppKit
import Foundation


let kCGMaxDisplayReservationInterval = CGDisplayReservationInterval(15.0)

func getInput() -> UnsafeMutablePointer<input_thread_t>? {
    let p_intf = getIntf()
    if p_intf == nil {
        return nil
    }
    return playlist_CurrentInput(pl_Get(p_intf))
}

func getVout() -> UnsafeMutablePointer<vout_thread_t>? {
    if let p_input = getInput() {
        let p_vout: UnsafeMutablePointer<vout_thread_t> = input_GetVout(p_input)
        vlc_object_release(UnsafeMutableRawPointer(p_input).bindMemory(to: vlc_object_t.self, capacity: 1))
        return p_vout
    }
    return nil
}

/**
 * Returns an array containing all the vouts.
 *
 * \return all vouts or nil if none is found
 */
func getVouts() -> [UnsafeMutablePointer<vout_thread_t>]? {
    let p_input = getInput()
    let pp_vouts = UnsafeMutablePointer<UnsafeMutablePointer<UnsafeMutablePointer<vout_thread_t>>>.allocate(capacity: 1)
    let numVouts = UnsafeMutablePointer<size_t>.allocate(capacity: 1)

    if p_input == nil || getInputControl(p_input!, Int32(INPUT_GET_VOUTS.rawValue), pp_vouts, numVouts) != 0 || numVouts.pointee == 0 {
        return nil
    }

    var vouts: [UnsafeMutablePointer<vout_thread_t>] = []
    for i in 0..<numVouts.pointee {
        vouts.append(pointer: pp_vouts.pointee[i])
    }
    free(pp_vouts)
    return vouts
}

func getInputControl(_ input: UnsafeMutablePointer<input_thread_t>, _ query: Int32, _ arguments: CVarArg...) -> Int32 {
    return withVaList(arguments) {
        return input_vaControl(input, query, $0)
    }
}

func getVoutForActiveWindow() -> UnsafeMutablePointer<vout_thread_t>? {
    if let currentWindow = NSApp.keyWindow as? VLCVideoWindow {
        return currentWindow.videoView.voutThread
    } else {
        return getVout()
    }
}

func getAout() -> UnsafeMutablePointer<audio_output_t>? {
    if let p_intf = getIntf() {
        return playlist_GetAout(pl_Get(p_intf))
    }
    return nil
}

func getURI(inputItem: UnsafeMutablePointer<input_item_t>) -> String? {
    if let psz_url = vlc_uri_decode(input_item_GetURI(inputItem)) {
        let url = String(cString: psz_url)
        free(psz_url)
        return url
    }
    return nil
}

func getTitleFbName(inputItem: UnsafeMutablePointer<input_item_t>) -> String {
    let psz_title_name = input_item_GetTitleFbName(inputItem)
    let title = String(cString: psz_title_name!)
    free(psz_title_name)
    return title
}

func vlc_tick_from_sec(_ secf: Double) -> vlc_tick_t {
    return (CLOCK_FREQ * secf)
}

func pl_CurrentInput(_ intf: UnsafeMutablePointer<intf_thread_t>) -> UnsafeMutablePointer<input_thread_t>? {
    return playlist_CurrentInput(pl_Get(intf))
}
