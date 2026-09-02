<img src="./image/line-neon.gif" width=100%><br>

<div id="user-content-toc">
  <ul align="center">
    <summary><h1 style="display: inline-block"><b>🔴 SYSURedHead</b></h1></summary>
    <a href="https://github.com/LulietLyan/SYSURedHead"><strong>查看文档 »</strong></a>
    <br />
    <a href="https://github.com/LulietLyan/SYSURedHead">演示</a>
    &middot;
    <a href="https://github.com/LulietLyan/SYSURedHead/issues/new?labels=bug&template=bug-report---.md">问题上报</a>
    &middot;
    <a href="https://github.com/LulietLyan/SYSURedHead/issues/new?labels=enhancement&template=feature-request---.md">特性</a>
  </ul>
</div>

<p align="center"> 
    <img src="https://img.shields.io/github/followers/LulietLyan?label=Followers&style=for-the-badge&color=purple"alt="github follow"/>
    <img src="https://img.shields.io/github/stars/LulietLyan/SYSURedHead?label=Stars&style=for-the-badge"
    alt="github repo stars" >
    <img src="https://img.shields.io/github/contributors/LulietLyan/SYSURedHead?style=for-the-badge&logoColor=%23985684"
    alt="contributors" >
    <img src="https://img.shields.io/github/issues-pr/LulietLyan/SYSURedHead?style=for-the-badge&color=%23985684"
    alt="issues-pr" >
    <img src="https://img.shields.io/github/issues/LulietLyan/SYSURedHead?style=for-the-badge&color=%23777777" 
    alt="issues" >
    <img src="https://img.shields.io/github/forks/LulietLyan/SYSURedHead?style=for-the-badge&color=%23187777" 
    alt="forks" >
    <img src="https://img.shields.io/github/license/LulietLyan/SYSURedHead?style=for-the-badge"
    alt="license" >
</p>

<p align="center"> 
<a href="https://github.com/LulietLyan/SYSURedHead"><img src="./image/SYSU.svg" height=50pt alt="lulietlyan" /></a>
<a href="https://github.com/LulietLyan/SYSURedHead"><img src="./image/NSCC-GZ.svg" height=50pt alt="lulietlyan" /></a>
</p>

<img src="./image/line-neon.gif" width=100%><br>

# 📕 Contents
- [📕 Contents](#-contents)
- [🤔 Introduction](#-introduction)
- [🤯 Where can I use it?](#-where-can-i-use-it)
- [🤩 Quick Start](#-quick-start)
- [❗ Declaration](#-declaration)
- [⭐ Star](#-star)
  - [扩展](#扩展)
    - [构建](#构建)
    - [新增 LaTeX 模块](#新增-latex-模块)
    - [新增示例](#新增示例)
    - [标准范围](#标准范围)
    - [Codex Skill 与 Plugin](#codex-skill-与-plugin)

# 🤔 Introduction

**SYSURedHead** 是一款以党政机关红头文件为主题的作业报告 LaTeX 模板

# 🤯 Where can I use it?

- **形势与政策、国家安全教育、劳动教育**: 每个学期都要写一份报告，不妨以最红的风格为您的辅导员交上一份满意的作业！
- **思政课作业**: 大多数思政课都要写报告，您也可以在此处大展身手。

# 🤩 Quick Start

- **Overleaf**：您可以在下载[项目压缩包](https://github.com/LulietLyan/SYSURedHead/archive/refs/heads/main.zip)后前往 [Overleaf](https://www.overleaf.com/) 导入压缩包开始进行文档代码编写
- **本地运行**：作者习惯在本地编写 LaTeX 代码。具体的环境配置可参考现有的各种博客如 [VSCode 配置 LaTeX 环境](https://zhuanlan.zhihu.com/p/166523064)

# ❗ Declaration

免责声明：**本人完全支持社会主义， 支持中国共产党的领导**，项目无不符合社会主义核心价值观的内容。本人坚决反对使用本项目作任何非法活动使用，本人完成本项目的初衷是为社区提供一款格式统一简便的党政机关主题的文档模板，任何利用本项目进行任何非法活动的个人或组织皆与本人无任何联系。

# ⭐ Star

如果您喜欢本项目，别忘了给作者一个 Star 😭

<img src="./image/line-neon.gif" width=100%><br>

---

## 扩展

新增 Codex skill，帮助您更快生成一份党政机关风格的文档

以下文档类、组件、示例和构建工具均为新增内容。原有 `RedHead.tex`、`RedHead.sty`、`RedHead.pdf`、字体和图片保持不变；旧的 LaTeX 中间文件不再纳入发布内容。

### 构建

新增构建需要 TeX Live 2023 或更高版本、XeLaTeX 和 `latexmk`。完整检查还需要 Bash、Python 3、`make` 和 Poppler 的 `pdfinfo`。

此外，您可以通过在线 LaTeX 编译器编译产物，因此本地 TeX 环境也不是必须的。

```bash
make root       # 将原 RedHead.tex 编译到 build/RedHead.pdf
make examples   # 同时编译原模板和 examples/ 下的新增示例
make check      # 运行编译、字段、A4 页面、plugin 和隔离生成检查
make clean      # 删除中间文件和测试 PDF，保留可供预览的文档 PDF
```

新增构建产物只写入 `build/`，不会覆盖根目录原有的 `RedHead.pdf`。仓库保留 `build/` 中的最终 PDF，方便 GitHub 用户直接查看排版效果。

### 新增 LaTeX 模块

```text
sysuredhead.cls             文档类入口和类选项
sysuredhead-fonts.sty       新增组件的字体与回退策略
sysuredhead-layout.sty      A4 版心、标题层级和双面页码
sysuredhead-components.sty  语义字段、版头、附件、落款和版记
```

新组件使用独立入口：

```tex
\documentclass{sysuredhead}

\RedHeadSetup{
  layout = normal,
  direction = down,
  authority = {示例市公共服务办公室},
  mark = {示例市公共服务办公室文件},
  document-number = {示公服发〔2026〕1号},
  title = {关于示例事项的通知},
  recipients = {各有关单位：},
  issuer = {示例市公共服务办公室},
  date = {2026年9月2日},
  draft-label = {排版示例，不具公文效力},
  seal = none
}

\begin{document}
\RedHeadMakeHead
这里填写正文。
\section{第一部分}
这里填写第一层内容。
\RedHeadMakeClosing
\RedHeadMakeImprint
\end{document}
```

新增公共组件：

| 接口 | 用途 |
| --- | --- |
| `\RedHeadSetup{...}` | 集中填写版式和公文字段 |
| `\RedHeadMakeHead` | 校验字段并生成版头、标题和主送机关 |
| `RedHeadAttachments` | 附件说明列表 |
| `RedHeadAttachment` | 附件首页、编号和标题 |
| `\RedHeadMakeClosing` | 署名、成文日期、文字占位和附注 |
| `\RedHeadMeetingList{...}{...}` | 纪要的出席、请假和列席信息 |
| `\RedHeadSealPlaceholder` | 明确写有“非印章”的位置占位 |
| `\RedHeadMakeImprint` | 抄送、印发机关和印发日期版记 |
| `\RedHeadValidate` | 显式运行字段一致性检查 |

`layout` 支持 `normal`、`letter`、`order`、`minutes` 和 `campus`；`direction` 支持 `down`、`up` 和 `parallel`。上行文缺少签发人、设置密级却缺少份号时会产生明确警告，未知枚举值会产生键值错误。

新增组件默认使用 TeX Live 提供的 Fandol 字体，不依赖原模板的 `xbs.ttf`。如已依法安装指定字体，可在新文档导言区使用：

```tex
\RedHeadSetMarkFont{本机字体名称}
```

字体不存在时会给出警告，这个策略只适用于新增的 `sysuredhead` 文档类，不改变原模板字体。

### 新增示例

原模板的当前编译效果见 [`build/RedHead.pdf`](./build/RedHead.pdf)。新增示例如下：

| 源码 | PDF 预览 | 场景 | 重点组件 |
| --- | --- | --- | --- |
| [`examples/notice.tex`](./examples/notice.tex) | [`notice.pdf`](./build/notice.pdf) | 普通下行通知 | 四级标题、两个附件、落款和版记 |
| [`examples/request.tex`](./examples/request.tex) | [`request.pdf`](./build/request.pdf) | 上行请示 | 发文字号与签发人并列 |
| [`examples/joint-notice.tex`](./examples/joint-notice.tex) | [`joint-notice.pdf`](./build/joint-notice.pdf) | 联合通知 | 多个虚构发文机关和联合署名 |
| [`examples/letter.tex`](./examples/letter.tex) | [`letter.pdf`](./build/letter.pdf) | 平行文函 | 信函版式 |
| [`examples/order.tex`](./examples/order.tex) | [`order.pdf`](./build/order.pdf) | 命令（令） | 令号、签发人职务和文字占位 |
| [`examples/minutes.tex`](./examples/minutes.tex) | [`minutes.pdf`](./build/minutes.pdf) | 会议纪要 | 出席、请假、列席和印发信息 |
| [`examples/campus-report.tex`](./examples/campus-report.tex) | [`campus-report.pdf`](./build/campus-report.pdf) | 校园报告 | 使用新增组件的独立创作示例 |

本项目所有新增示例均使用虚构机关、编号、姓名和日期，不具公文效力。

### 标准范围

新增组件参考 [GB/T 9704-2012《党政机关公文格式》](https://std.samr.gov.cn/gb/search/gbDetailed?id=lOIe27f77QU%3D&mode=p) 的纸张、版心、正文层级和组成要素。该推荐性国家标准在 2025-05-30 复审后继续有效，本说明核验于 2026-09-02。文种和行文规则参考 [《党政机关公文处理工作条例》](https://www.gov.cn/zhengce/2013-02/22/content_2640088.htm)。

本扩展只提供纸面排版参考，不代表官方认证，也不提供电子公文交换、签章和归档功能。正式使用时应以届时有效的国家标准、本机关实施细则及有权部门审核意见为准。

### Codex Skill 与 Plugin

仓库新增 skills-only plugin `sysu-redhead`，遵循当前 [OpenAI Build skills](https://learn.chatgpt.com/docs/build-skills) 和 [Build plugins](https://learn.chatgpt.com/docs/build-plugins) 约定。安装后提供 `$redhead-document` skill，用于创建自包含的新增组件项目。

克隆仓库后，可直接用命令安装独立 skill：

```bash
./scripts/install-skill.sh
```

默认安装到 `~/.agents/skills/redhead-document`。也可以通过 `--skills-dir <目录>` 安装到指定的 skills 目录；安装器不会覆盖已有目录。

也可以在 Codex 中调用内置安装器，从 GitHub 安装该 skill：

```text
$skill-installer install redhead-document from https://github.com/LulietLyan/SYSURedHead/tree/main/plugins/sysu-redhead/skills/redhead-document
```

若希望以可更新的 plugin 形式安装，则执行：

```bash
codex plugin marketplace add LulietLyan/SYSURedHead --ref main
codex plugin add sysu-redhead@sysu-redhead
```

在当前检出目录测试：

```bash
codex plugin marketplace add .
codex plugin add sysu-redhead@sysu-redhead
```

调用示例：

```text
$redhead-document 使用虚构字段创建一份通知 LaTeX 草稿，并在本地编译检查。
```

skill 支持 `notice`、`request`、`joint`、`letter`、`order`、`minutes` 和 `campus`。初始化脚本默认拒绝覆盖已有内容：

```bash
plugins/sysu-redhead/skills/redhead-document/scripts/init-document.sh \
  --type notice \
  --output ./draft-notice
make -C ./draft-notice
```
