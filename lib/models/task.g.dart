// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      icon: fields[3] as String,
      starsPerCompletion: fields[4] as int,
      startDate: fields[5] as DateTime,
      repeatPattern: fields[6] as String,
      timeOfDay: fields[7] as String,
      time: fields[8] as DateTime?,
      photoProof: fields[9] as bool,
    )..completedDatesTimestamps = (fields[10] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.starsPerCompletion)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.repeatPattern)
      ..writeByte(7)
      ..write(obj.timeOfDay)
      ..writeByte(8)
      ..write(obj.time)
      ..writeByte(9)
      ..write(obj.photoProof)
      ..writeByte(10)
      ..write(obj.completedDatesTimestamps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
