import { display } from '@kit.ArkUI';
import { inputMethodEngine, InputMethodExtensionContext } from '@kit.IMEKit';

// 调用输入法框架的getInputMethodAbility方法获取实例，并由此实例调用输入法框架功能接口
const inputMethodAbility: inputMethodEngine.InputMethodAbility = inputMethodEngine.getInputMethodAbility();

export class KeyboardController {
  private mContext: InputMethodExtensionContext | undefined = undefined; // 保存InputMethodExtensionAbility中的context属性
  private panel: inputMethodEngine.Panel | undefined = undefined;
  private textInputClient: inputMethodEngine.InputClient | undefined = undefined;
  private keyboardController: inputMethodEngine.KeyboardController | undefined = undefined;

  constructor() {
  }

  public onCreate(context: InputMethodExtensionContext): void
  {
    this.mContext = context;
    this.initWindow(); // 初始化窗口
    this.registerListener(); // 注册对输入法框架的事件监听
  }

  public onDestroy(): void // 应用生命周期销毁
  {
    this.unRegisterListener(); // 去注册事件监听
    if(this.panel) { // 销毁窗口
      this.panel.hide();
      inputMethodAbility.destroyPanel(this.panel);
    }
    if(this.mContext) {
      this.mContext.destroy();
    }
  }

  public insertText(text: string): void {
    if(this.textInputClient) {
      this.textInputClient.insertText(text);
    }
  }

  public deleteForward(length: number): void {
    if(this.textInputClient) {
      this.textInputClient.deleteForward(length);
    }
  }

  private initWindow(): void // 初始化窗口
  {
    if(this.mContext === undefined) {
      return;
    }
    let dis = display.getDefaultDisplaySync();
    let dWidth = dis.width;
    let dHeight = dis.height;
    let keyHeightRate = 0.0;
    let keyHeight = dHeight * keyHeightRate;
    let nonBarPosition = dHeight - keyHeight;
    let panelInfo: inputMethodEngine.PanelInfo = {
      type: inputMethodEngine.PanelType.SOFT_KEYBOARD,
      flag: inputMethodEngine.PanelFlag.FLG_FIXED
    };
    inputMethodAbility.createPanel(this.mContext, panelInfo).then(async (inputPanel: inputMethodEngine.Panel) => {
      this.panel = inputPanel;
      if(this.panel) {
        await this.panel.resize(dWidth, keyHeight);
        await this.panel.moveTo(0, nonBarPosition);
        await this.panel.setUiContent('InputMethodExtensionAbility/pages/Index');
      }
    });
  }

  private registerListener(): void
  {
    this.registerInputListener(); // 注册对输入法框架服务的监听
    // 注册隐藏键盘事件监听等
  }

  private registerInputListener(): void { // 注册对输入法框架服务的开启及停止事件监听
    inputMethodAbility.on('inputStart', (kbController, textInputClient) => {
      this.textInputClient = textInputClient; // 此为输入法客户端实例，由此调用输入法框架提供给输入法应用的功能接口
      this.keyboardController = kbController;
    })
    inputMethodAbility.on('inputStop', () => {
      this.onDestroy(); // 销毁KeyboardController
    });
  }

  private unRegisterListener(): void
  {
    inputMethodAbility.off('inputStart');
    inputMethodAbility.off('inputStop', () => {});
  }
}

const keyboardController = new KeyboardController();

export default keyboardController;