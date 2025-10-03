import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../contoller/commit_repleiy_controller/add_commit_controller.dart';
import '../../contoller/commit_repleiy_controller/get_commit_controller.dart';
import '../../contoller/commit_repleiy_controller/get_reply_commit_controller.dart';
import '../../contoller/commit_repleiy_controller/reply_commit_controller.dart';

class ReplyTarget {
  final int id;
  final bool isReply;

  ReplyTarget(this.id, {this.isReply = false});
}

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final int lessonId;

  const VideoPlayerPage({
    Key? key,
    required this.videoUrl,
    required this.lessonId,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  final CommentController commentController = Get.put(CommentController());
  final ReplyCommentController replyCommentController =
      Get.put(ReplyCommentController());
  final ReplyListController replyListController =
      Get.put(ReplyListController());

  final SendCommentController sendCommentController = Get.put(SendCommentController());

  final TextEditingController _commentController = TextEditingController();

  // تحكم بالردود على التعليقات
  final Map<int, TextEditingController> replyControllers = {};

  // تحكم بالردود على الردود
  final Map<int, TextEditingController> replyToReplyControllers = {};

  ReplyTarget? replyingTo; // لتحديد اذا نرد على تعليق او رد

  bool _isLoading = true;

  // خريطة لتتبع حالة ظهور الردود لكل تعليق (true = الردود ظاهرة)
  final Map<int, bool> showRepliesForComment = {};

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading video: $error')),
        );
      });

    commentController.fetchCommentsForLesson(widget.lessonId);
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();

    replyControllers.forEach((_, controller) => controller.dispose());
    replyToReplyControllers.forEach((_, controller) => controller.dispose());

    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  Future<void> _submitMainComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    await sendCommentController.sendReply(
      lessonId: widget.lessonId,
      content: text,
    );

    _commentController.clear();
    await commentController.fetchCommentsForLesson(widget.lessonId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added successfully')),
    );
  }

  Future<void> _submitReply(int commentId) async {
    final text = replyControllers[commentId]?.text.trim() ?? '';
    if (text.isEmpty) return;

    await replyCommentController.sendReply(
      lessonId: widget.lessonId,
      content: text,
      parentId: commentId,
    );

    replyControllers[commentId]?.clear();
    setState(() {
      replyingTo = null;
    });

    await commentController.fetchCommentsForLesson(widget.lessonId);
    // تحديث الردود لهذا التعليق بعد الرد
    await replyListController.fetchReplies(commentId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply added successfully')),
    );
  }

  Future<void> _submitReplyToReply(int replyId) async {
    final text = replyToReplyControllers[replyId]?.text.trim() ?? '';
    if (text.isEmpty) return;

    await replyCommentController.sendReply(
      lessonId: widget.lessonId,
      content: text,
      parentId: replyId,
    );

    replyToReplyControllers[replyId]?.clear();
    setState(() {
      replyingTo = null;
    });

    await commentController.fetchCommentsForLesson(widget.lessonId);
    await replyListController.fetchReplies(replyId);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reply to reply added successfully')),
    );
  }

  // دالة لتبديل عرض الردود عند الضغط على زر "عرض الردود"
  Future<void> _toggleShowReplies(int commentId) async {
    bool currentlyShown = showRepliesForComment[commentId] ?? false;
    if (currentlyShown) {
      // إذا الردود ظاهرة، قم بإخفائها فقط
      setState(() {
        showRepliesForComment[commentId] = false;
      });
    } else {
      // إذا الردود مخفية، قم بتحميلها أولاً ثم إظهارها
      await replyListController.fetchReplies(commentId);
      setState(() {
        showRepliesForComment[commentId] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Video Player', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _controller.value.isInitialized
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            VideoPlayer(_controller),
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black45,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 64,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.teal,
                                  backgroundColor: Colors.grey[300]!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _commentController,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Add Comment',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Colors.teal),
                                  onPressed: _submitMainComment,
                                  tooltip: 'Send comment',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'All Comments',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Obx(() {
                              if (commentController.isLoading.value) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (commentController.comments.isEmpty) {
                                return const Text('No comments found.');
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: commentController.comments.length,
                                itemBuilder: (context, index) {
                                  final comment =
                                      commentController.comments[index];
                                  final createdAt = comment.createdAt.toLocal();
                                  final date =
                                      "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";
                                  final time =
                                      "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

                                  replyControllers.putIfAbsent(comment.id,
                                      () => TextEditingController());

                                  bool isShowingReplies =
                                      showRepliesForComment[comment.id] ??
                                          false;

                                  return Card(
                                    color: Colors.teal.shade50,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            comment.user.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            comment.content,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey.shade800),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(time,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .grey.shade500)),
                                                  Text(date,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors
                                                              .grey.shade500)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TextButton.icon(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (replyingTo !=
                                                                null &&
                                                            replyingTo!.id ==
                                                                comment.id &&
                                                            !replyingTo!
                                                                .isReply) {
                                                          replyingTo = null;
                                                        } else {
                                                          replyingTo =
                                                              ReplyTarget(
                                                                  comment.id,
                                                                  isReply:
                                                                      false);
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.reply,
                                                        size: 18,
                                                        color: Colors.teal),
                                                    label: const Text("Reply",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.teal)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        _toggleShowReplies(
                                                            comment.id),
                                                    child: Text(
                                                      isShowingReplies
                                                          ? "Hide Replies"
                                                          : "Show Replies",
                                                      style: const TextStyle(
                                                          color: Colors.teal),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          if (replyingTo != null &&
                                              replyingTo!.id == comment.id &&
                                              !replyingTo!.isReply) ...[
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller:
                                                  replyControllers[comment.id],
                                              decoration: InputDecoration(
                                                hintText: "Write your reply...",
                                                border:
                                                    const OutlineInputBorder(),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(Icons.send,
                                                      color: Colors.teal),
                                                  onPressed: () =>
                                                      _submitReply(comment.id),
                                                ),
                                              ),
                                            ),
                                          ],
                                          if (isShowingReplies)
                                            Obx(() {
                                              final repliesForComment =
                                                  replyListController.replies
                                                      .where((r) =>
                                                          r.parentId ==
                                                          comment.id)
                                                      .toList();

                                              if (replyListController
                                                  .isLoading.value) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                              if (repliesForComment.isEmpty)
                                                return const SizedBox.shrink();

                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16, top: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: repliesForComment
                                                      .map((reply) {
                                                    replyToReplyControllers
                                                        .putIfAbsent(
                                                            reply.id,
                                                            () =>
                                                                TextEditingController());

                                                    final isReplyingToThis =
                                                        replyingTo != null &&
                                                            replyingTo!.id ==
                                                                reply.id &&
                                                            replyingTo!.isReply;

                                                    final replyCreatedAt = reply
                                                        .createdAt
                                                        .toLocal();
                                                    final replyDate =
                                                        "${replyCreatedAt.year}-${replyCreatedAt.month.toString().padLeft(2, '0')}-${replyCreatedAt.day.toString().padLeft(2, '0')}";
                                                    final replyTime =
                                                        "${replyCreatedAt.hour.toString().padLeft(2, '0')}:${replyCreatedAt.minute.toString().padLeft(2, '0')}";

                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Card(
                                                            color: Colors
                                                                .grey.shade100,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    reply.user
                                                                        .name,
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(reply
                                                                      .content),
                                                                  const SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    "$replyTime | $replyDate",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade600),
                                                                  ),
                                                                  TextButton
                                                                      .icon(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (replyingTo !=
                                                                                null &&
                                                                            replyingTo!.id ==
                                                                                reply.id &&
                                                                            replyingTo!.isReply) {
                                                                          replyingTo =
                                                                              null;
                                                                        } else {
                                                                          replyingTo = ReplyTarget(
                                                                              reply.id,
                                                                              isReply: true);
                                                                        }
                                                                      });
                                                                    },
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .reply,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .teal),
                                                                    label: const Text(
                                                                        "Reply",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.teal)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (isReplyingToThis) ...[
                                                          const SizedBox(
                                                              height: 8),
                                                          TextField(
                                                            controller:
                                                                replyToReplyControllers[
                                                                    reply.id],
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Write your reply...",
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              suffixIcon:
                                                                  IconButton(
                                                                icon: const Icon(
                                                                    Icons.send,
                                                                    color: Colors
                                                                        .teal),
                                                                onPressed: () =>
                                                                    _submitReplyToReply(
                                                                        reply
                                                                            .id),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    );
                                                  }).toList(),
                                                ),
                                              );
                                            }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('Error loading video')),
    );
  }
}
