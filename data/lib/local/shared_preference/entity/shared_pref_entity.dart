// This class is used to save, retrieve and delete data from shared preferences
import 'package:data/local/shared_preference/shared_pref_manager.dart';
import 'package:data/model/mappable.dart';

abstract class SharedPrefEntity implements Mappable {
  abstract String sharedPrefKey;

  final SharedPrefManager _sharedPrefManager = SharedPrefManager();

  Future<void> saveToSharedPref() {
    return _sharedPrefManager.saveValue(
      sharedPrefKey,
      this,
      modelToJsonConverter: (model) => model.toJson(),
    );
  }

  //TODO: Find an way to make this method static so that it can be called without creating an instance of the class
  Future<Mappable?> getFromSharedPref() async {
    return _sharedPrefManager.getValue(
      sharedPrefKey,
      this,
      convertJsonToModel: (json) => fromJson(json),
    );
  }

  Future<bool> deleteFromSharedPref() async {
    return _sharedPrefManager.clear(sharedPrefKey);
  }
}
