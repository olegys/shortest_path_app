import 'package:equatable/equatable.dart';

class Point extends Equatable {
  const Point(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];

  @override
  String toString() => '($x.$y)';
}
