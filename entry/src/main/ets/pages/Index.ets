import { inputMethod } from '@kit.IMEKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BUNDLE_NAME } from 'BuildProfile';

@Entry
@Component
struct Index {
  build() {
    Column() {
      TextInput({ placeholder: "点击切换输入法" })
    }
  }

  async onPageShow(): Promise<void> {
    let inputMethodSetting = inputMethod.getSetting();
    inputMethodSetting.showOptionalInputMethods()
    let inputMethods = await inputMethod.getSetting().getInputMethods(true); // 获取已使能的输入法列表
    let currentInputMethod = inputMethod.getCurrentInputMethod(); // 获取当前输入法
    if (currentInputMethod.name != BUNDLE_NAME) {
      for (let i = 0; i < inputMethods.length; i++) {
        if (inputMethods[i].name == BUNDLE_NAME) { // 判断不是当前输入法时，切换到该输入法，实际开发中可以切换到固定输入法
          let result = await inputMethod.switchInputMethod(inputMethods[i]);
          console.log("yyy:" + inputMethods[i].name)
          console.log("yyy:切换成功吗"+result);
        }
      }
    }
  }
}
