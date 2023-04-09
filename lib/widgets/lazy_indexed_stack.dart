import 'package:flutter/material.dart';

class LazyIndexedStack extends StatefulWidget {
  const LazyIndexedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  }) : super(key: key);

  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int? index;
  final List<Widget> children;

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  final List<bool> _activatedList = [];

  void _activateIndex(int? index) {
    if (index == null) {
      return;
    }
    if (!_activatedList[index]) {
      _activatedList[index] = true;
    }
  }

  List<Widget> _buildChildren(BuildContext context) {
    return <Widget>[
      for (int i = 0; i < widget.children.length; i++)
        if (_activatedList[i] == true)
          widget.children[i]
        else
          const SizedBox.shrink(),
    ];
  }

  void _refreshList() {
    _activatedList.clear();
    _activatedList.addAll(List<bool>.generate(
      widget.children.length,
          (int i) => i == widget.index,
    ));
  }

  @override
  void initState() {
    _activatedList.addAll(List<bool>.generate(
      widget.children.length,
          (int i) => i == widget.index,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_activatedList.length != widget.children.length) {
      _refreshList();
    }
    _activateIndex(widget.index);
    return IndexedStack(
      alignment: widget.alignment,
      sizing: widget.sizing,
      textDirection: widget.textDirection,
      index: widget.index,
      children: _buildChildren(context),
    );
  }
}