//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <firebase_core/firebase_core_plugin_c_api.h>
#include <flutter_barcode_sdk/flutter_barcode_sdk_plugin.h>
#include <pasteboard/pasteboard_plugin.h>
#include <validation_pro/validation_pro_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  FlutterBarcodeSdkPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterBarcodeSdkPlugin"));
  PasteboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasteboardPlugin"));
  ValidationProPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ValidationProPluginCApi"));
}
