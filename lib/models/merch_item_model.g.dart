// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merch_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MerchItemAdapter extends TypeAdapter<MerchItem> {
  @override
  final int typeId = 1;

  @override
  MerchItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MerchItem(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      priceJpy: fields[3] as double,
      imageUrl: fields[4] as String,
      category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MerchItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priceJpy)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MerchItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
