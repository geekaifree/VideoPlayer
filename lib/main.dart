import 'package:flutter/material.dart';

void main() => runApp(const VideoPlayerApp());
class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(title: '极速播放器', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.red, useMaterial3: true, brightness: Brightness.dark),
    home: const PlayerHomePage());
}

class VideoFile {
  final String name, path, duration, size, resolution;
  final bool isPlaying;
  VideoFile({required this.name, required this.path, required this.duration, required this.size, required this.resolution, this.isPlaying = false});
}

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});
  @override
  State<PlayerHomePage> createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  final _videos = [
    VideoFile(name: '演示视频.mp4', path: '~/Videos/', duration: '12:34', size: '256MB', resolution: '1080p'),
    VideoFile(name: '会议录像.mov', path: '~/Videos/', duration: '1:23:45', size: '1.2GB', resolution: '4K'),
    VideoFile(name: '教程视频.mkv', path: '~/Downloads/', duration: '45:20', size: '680MB', resolution: '720p'),
    VideoFile(name: '音乐MV.mp4', path: '~/Music/', duration: '4:32', size: '85MB', resolution: '1080p'),
    VideoFile(name: '直播回放.flv', path: '~/Downloads/', duration: '2:10:00', size: '2.1GB', resolution: '1080p'),
  ];

  VideoFile? _current;
  double _position = 0;
  double _volume = 0.8;
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎬 极速播放器'), centerTitle: true, actions: [
        IconButton(icon: const Icon(Icons.playlist_play), onPressed: () {}, tooltip: '播放列表'),
      ]),
      body: Column(children: [
        // 视频画面区域
        Container(height: 220, color: Colors.black, child: _current != null ? Stack(alignment: Alignment.center, children: [
          Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(_playing ? Icons.play_circle_filled : Icons.pause_circle_filled, size: 64, color: Colors.white.withOpacity(0.8)),
            const SizedBox(height: 8),
            Text(_current!.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text('${_current!.resolution} • ${_current!.duration}', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
          ])),
          // 进度条
          Positioned(bottom: 0, left: 0, right: 0, child: SliderTheme(data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)), child: Slider(value: _position, onChanged: (v) => setState(() => _position = v), activeColor: Colors.red))),
          // 控制栏
          Positioned(bottom: 20, left: 16, right: 16, child: Row(children: [
            Text(_formatTime(_position, _current!.duration), style: const TextStyle(color: Colors.white, fontSize: 11)),
            const Spacer(),
            IconButton(icon: Icon(_playing ? Icons.pause : Icons.play_arrow, color: Colors.white), onPressed: () => setState(() => _playing = !_playing)),
            const Spacer(),
            Text(_current!.duration, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
          ])),
        ]) : Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.videocam, size: 64, color: Colors.grey.shade700), const SizedBox(height: 8), Text('选择视频开始播放', style: TextStyle(color: Colors.grey.shade600))])),
        ),
        // 音量控制
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [
          IconButton(icon: Icon(_volume > 0 ? Icons.volume_up : Icons.volume_off, size: 20), onPressed: () => setState(() => _volume = _volume > 0 ? 0 : 0.8)),
          Expanded(child: Slider(value: _volume, onChanged: (v) => setState(() => _volume = v), activeColor: Colors.red)),
          Text('${(_volume * 100).toInt()}%', style: const TextStyle(fontSize: 12)),
        ])),
        const Divider(height: 1),
        // 播放列表
        Expanded(child: ListView.builder(itemCount: _videos.length, itemBuilder: (ctx, i) {
          final v = _videos[i];
          final isCurrent = _current?.path == v.path && _current?.name == v.name;
          return ListTile(
            leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: isCurrent ? Colors.red.withOpacity(0.2) : Colors.grey.shade800, borderRadius: BorderRadius.circular(8)), child: Center(child: Icon(isCurrent ? Icons.play_circle_filled : Icons.videocam, color: isCurrent ? Colors.red : Colors.grey))),
            title: Text(v.name, style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : null, color: isCurrent ? Colors.red : null)),
            subtitle: Text('${v.duration} • ${v.size} • ${v.resolution}', style: const TextStyle(fontSize: 12)),
            trailing: Text(v.resolution, style: TextStyle(fontSize: 11, color: v.resolution == '4K' ? Colors.orange : Colors.grey)),
            onTap: () => setState(() { _current = v; _playing = true; _position = 0; }),
          );
        })),
      ]),
    );
  }

  String _formatTime(double pos, String total) {
    final parts = total.split(':');
    int totalSec = parts.length == 3 ? int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]) : int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final current = (pos * totalSec).toInt();
    final m = (current ~/ 60).toString().padLeft(2, '0');
    final s = (current % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
