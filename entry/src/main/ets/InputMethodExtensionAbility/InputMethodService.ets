import { Want } from '@kit.AbilityKit';
import keyboardController from './KeyboardController';
import { InputMethodExtensionAbility } from '@kit.IMEKit';

export default class InputDemoService extends InputMethodExtensionAbility {

  onCreate(want: Want): void {
    keyboardController.onCreate(this.context); // 初始化窗口并注册对输入法框架的事件监听
  }

  onDestroy(): void {
    console.log("onDestroy.");
    keyboardController.onDestroy(); // 销毁窗口并去注册事件监听
  }
}