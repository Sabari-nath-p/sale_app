//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <simple_animation_progress_bar/simple_animation_progress_bar_plugin_c_api.h>
#include <smart_auth/smart_auth_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  SimpleAnimationProgressBarPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SimpleAnimationProgressBarPluginCApi"));
  SmartAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SmartAuthPlugin"));
}
