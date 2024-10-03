# FishGameGodot

[English README.md](/README.md)

**"Fish Game" for Godot** 是一款为 [Godot](https://godotengine.org/) 制作的 2-4 人在线游戏，它展示了 [Nakama](https://heroiclabs.com/)（一个开源可扩展的游戏服务器）的功能。

![Animated GIF showing gameplay](assets/screenshots/gameplay.gif)

你可以从发布页面[Releases page](https://github.com/Liweimin0512/fishgame-godot4/releases)下载 Windows、Linux 和 MacOS 的
可玩构建版本。

## 功能展示

"Fish Game" 展示了以下 Nakama 功能：

- [用户认证](https://heroiclabs.com/docs/authentication/)
- [匹配](https://heroiclabs.com/docs/gameplay-matchmaker/)
- [排行榜](https://heroiclabs.com/docs/gameplay-leaderboards/)
- [实时多人游戏](https://heroiclabs.com/docs/gameplay-multiplayer-realtime/)

游戏设计深受 [《Duck Game》](https://store.steampowered.com/app/312530/Duck_Game/) 的启发;

## 计划开发

老李计划在原版游戏内容基础上添加更多展示nakama服务器框架功能的内容，这其中包括：

- [ ] 好友系统
- [ ] 公会系统
- [ ] 数据存储
- [ ] 邮件通知
- [ ] 后端脚本改用Typescript（我承认lua很好，但只是个人习惯）

## 控制方式

### 在线游戏

**游戏手柄:**

- **D-PAD** or **LEFT ANALOG STICK** = 控制你的鱼移动
- **A (XBox)** or **Cross (PS)** = 跳跃
- **Y (XBox)** or **Triangle (PS)** = 捡起/投掷武器
- **X (XBox)** or **Square (PS)** = 使用武器
- **B (Xbox)** or **Circle (PS)** = 发出气泡声

**键盘:**

- **W**, **A**, **S**, **D** = 控制你的鱼移动
- **C** = 捡起/投掷武器
- **V** = 使用武器
- **E** = 发出气泡声

### 本地游戏

**游戏手柄:**

与“在线游戏”控制方式相同。

**键盘:**

| 动作           | 玩家1                       | 玩家2       |
| -------------- | -------------------------- | ----------  |
| 移动           | **W**, **A**, **S**, **D** | Arrow keys  |
| 拾取、投掷武器  | **C**                      | **L**       |
| 使用武器       | **V**                       | **;**       |
| 发出气泡声     | **E**                       | **P**       |

## 从源代码玩游戏

### 依赖项

你将需要：

- [Godot](https://godotengine.org/download) 4.3 或更高版本。
- 一个 Nakama 服务器（版本 2.15.0 或更高）来连接。

通过 [Docker](https://heroiclabs.com/docs/install-docker-quickstart/) 搭建 Nakama 服务器进行测试/学习最简单的方法是，实际上，“Fish Game”的源代码中包含了一个 `docker-compose.yml` 文件。

所以，如果你的系统上安装了 [Docker Compose](https://docs.docker.com/compose/install/)，你只需要转到你放置“Fish Game”源代码的目录并运行此命令：

```sh
docker-compose up -d
```

### 从源代码运行游戏

1. 将源代码下载到你的计算机。
2. 在 [Godot](https://godotengine.org/download) 中“导入”项目。
3. （可选）编辑 [autoload/Online.gd](https://github.com/Liweimin0512/fishgame-godot4/blob/main/autoload/Online.gd) 文件，并用你的 Nakama 服务器的正确值替换顶部的变量。
如果你使用默认设置本地运行 Nakama 服务器，那么你应该不需要更改任何东西。
4. 按 F5 或点击右上角的播放按钮开始游戏。

### 设置排行榜

如果你没有使用“Fish Game”中包含的 `docker-compose.yml`，那么“排行榜”将不会工作，直到你首先在服务器上创建它。

要做到这一点，复制 `nakama/data/modules/fish_game.lua` 文件到你的 Nakama 服务器保存其数据的 modules/ 目录中，然后重启你的 Nakama 服务器。

> **注意：没有排行榜，游戏也能正常玩。**

## 许可证

该项目根据 Apache 2.0 许可证获得许可，有以下例外：

- 字体（在 [assets/fonts/](https://github.com/Liweimin0512/fishgame-godot4/blob/main/assets/fonts) 中）和一些艺术资产（在 [assets/kenney-platform-deluxe/](https://github.com/Liweimin0512/fishgame-godot4/blob/main/assets/kenney-platform-deluxe) 中）源自 CC0 资源（见 [CREDITS-CC0.txt](https://github.com/Liweimin0512/fishgame-godot4/blob/main/CREDITS-CC0.txt)）。
- 其余的艺术、音乐和声音资产根据 [CC BY-NC License](https://github.com/Liweimin0512/fishgame-godot4/blob/main/assets/LICENSE.txt) 许可证获得许可。
- 包含在 [addons/snopek-state-machine/](https://github.com/Liweimin0512/fishgame-godot4/tree/main/addons/snopek-state-machine) 中的 Snopek 状态机根据 MIT 许可证获得许可。
- 大部分 UI 代码（包含在 [main/](https://github.com/Liweimin0512/fishgame-godot4/tree/main/main) 中）和一些其他辅助代码文件[源自 Godot 的 WebRTC 和 Nakama 插件](https://gitlab.com/snopek-games/godot-nakama-webrtc)，根据 MIT 许可证获得许可。

### 许可协议解释说明

 这里对上述许可协议进行简单的解释说明。

- **Apache 2.0 许可证**：一个宽松的开源许可证，允许用户自由地使用、修改和分发软件，包括商业用途。
  - 要求分发的软件必须包含原始许可证和版权声明。
  - 允许分发修改后的版本，但必须在修改的版本中明确标识出更改。
  - 提供专利授权，保护用户不受专利诉讼的影响。
- **CC0（Creative Commons Zero）**：公共领域奉献工具，允许创作者放弃他们的作品的所有版权和相关权利。
  - 这意味着任何人都可以自由地使用、复制、修改、分发和执行作品，甚至用于商业目的，无需请求许可。
  - CC0 作品不要求署名，但道德上应该给予原作者适当的信用。
- **CC BY-NC License（Creative Commons Attribution-NonCommercial）**：一个创意共享许可证，要求署名（BY）且不得用于商业用途（NC）。
  - 允许用户非商业性地分享和修改作品，但必须提供原作者的署名。
  - 如果作品被修改或衍生，必须在新作品中标明更改。
- **MIT 许可证**：一个非常宽松的开源许可证，允许用户自由地使用、修改和分发软件，包括商业用途。
  - 要求分发的软件必须包含原始许可证的副本。
  - 不要求分发修改后的版本包含修改的记录，但必须包含原始许可证
