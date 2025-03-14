import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamListScreen extends StatefulWidget {
  const LiveStreamListScreen({super.key});

  @override
  _LiveStreamListScreenState createState() => _LiveStreamListScreenState();
}

class _LiveStreamListScreenState extends State<LiveStreamListScreen> {
  final _liveStreamController = Get.find<LiveStreamController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _liveStreamController.fetchActiveStreams();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _liveStreamController.activeStreams.clear();
    _liveStreamController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Obx(
          () {
            if (_liveStreamController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (_liveStreamController.activeStreams.isEmpty) {
              return const Center(
                child: Text('No live streams available.'),
              );
            } else {
              return GridView.builder(
                itemCount: _liveStreamController.activeStreams.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.73,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 15.0,
                ),
                itemBuilder: (context, index) {
                  final stream = _liveStreamController.activeStreams[index];
                  return InkWell(
                    onTap: () async {
                      _liveStreamController.joinLiveStream(
                        stream.channelName,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(stream.hostAvater),
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 20,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                ),
                                child: const Text(
                                  "LIVE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                height: 20,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  stream.viewers.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              // return ListView.builder(
              //   itemCount: _liveStreamController.activeStreams.length,
              //   itemBuilder: (context, index) {
              //     final stream = _liveStreamController.activeStreams[index];
              //     return ListTile(
              //       leading: const Icon(Icons.live_tv, color: Colors.red),
              //       title: Text(stream.channelName),
              //       subtitle: Text('Hosted by: ${stream.hostId}'),
              //       onTap: () async {
              //         _liveStreamController.joinLiveStream(
              //           stream.channelName,
              //         );
              //       },
              //     );
              //   },
              // );
            }
          },
        ),
      ),
    );
  }
}
