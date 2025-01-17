import 'package:flutter/material.dart';

typedef DataBuilder<T> = Widget Function(BuildContext context, T data);

class StreamContentHandler<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget loadingWidget;
  final Widget Function(BuildContext, dynamic)? errorBuilder;
  final Widget emptyWidget;
  final DataBuilder<T> builder;

  const StreamContentHandler({
    super.key,
    required this.stream,
    required this.loadingWidget,
    required this.emptyWidget,
    required this.builder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        } else if (snapshot.hasError) {
          return errorBuilder != null
              ? errorBuilder!(context, snapshot.error)
              : Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || (snapshot.data is List && (snapshot.data as List).isEmpty)) {
          return emptyWidget;
        } else {
          return builder(context, snapshot.data!);
        }
      },
    );
  }
}
