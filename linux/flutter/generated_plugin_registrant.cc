//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_barcode_sdk/flutter_barcode_sdk_plugin.h>
#include <pasteboard/pasteboard_plugin.h>
#include <validation_pro/validation_pro_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_barcode_sdk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterBarcodeSdkPlugin");
  flutter_barcode_sdk_plugin_register_with_registrar(flutter_barcode_sdk_registrar);
  g_autoptr(FlPluginRegistrar) pasteboard_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PasteboardPlugin");
  pasteboard_plugin_register_with_registrar(pasteboard_registrar);
  g_autoptr(FlPluginRegistrar) validation_pro_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ValidationProPlugin");
  validation_pro_plugin_register_with_registrar(validation_pro_registrar);
}
