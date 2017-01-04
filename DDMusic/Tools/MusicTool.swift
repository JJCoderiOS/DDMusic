

import UIKit
import AVFoundation
/*
 播放工具类 ：
 下一首
 上一首
 暂停
 停止
 快进
 快退等功能
 */

let kPlayFinishNotification = "kPlayFinishNotification"


class MusicTool: NSObject {

    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            try session.setActive(true)
        } catch {
            print(error)
            return
        }
    }
    var player : AVAudioPlayer?
    func playMusicWithName(musicName : String) {
        //1 获取播放路径
        guard  let path = Bundle.main.url(forResource: musicName, withExtension: nil) else {
            return
        }
        
        //如果是正在播放则 return
        if player?.url == path {
            player?.play()
            
            return
        }
        //2 根据路径创建播放器 因为AVAudioPlayer 需要thorw 穿透
        do {
            player = try AVAudioPlayer(contentsOf: path)
            player?.delegate = self
        } catch {
            print(error)
            return
        }
        //3 准备播放
        player?.prepareToPlay()
        //4 开始播放
        
        player?.play()
    }
    /* 暂停 */
    func pauseMusic() -> () {
        player?.pause()
    }
    /* 获得当前播放比例 */
    func getCurrnetPlayerPlayRotate() -> CGFloat {
        let rotate = (player?.currentTime)! / (player?.duration)!
        return CGFloat(rotate)
    }
    
}

extension MusicTool : AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotification), object: self, userInfo: nil)
    }
    
}
