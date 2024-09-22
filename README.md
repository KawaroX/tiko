# Tiko - Text Comparison Tool | 文本比较工具

[English](#english) | [中文](#中文)

<a name="english"></a>
## English

Tiko is a web-based application that allows users to compare two pieces of text and analyze their similarities and differences. Built with Flutter for the frontend and Python Flask for the backend, Tiko provides a user-friendly interface for text comparison tasks.

### Features

- Compare two text inputs
- Ignore whitespace option
- Ignore punctuation differences option
- Custom comparison rules
- Similarity percentage display
- Detailed difference highlighting

#### Custom Rules

Tiko allows users to define custom comparison rules. These rules can be used to treat certain strings as equivalent during the comparison process.

##### How to Use Custom Rules

1. Enable the "Use Custom Rules" option in the application.
2. Click on "Edit Custom Rules" to open the rules editor.
3. Enter your rules in the following format:
   ```
   - string1:string2
   ```
   or
   ```
   * string1:string2
   ```
   Each rule should be on a new line.

4. The comparison will treat `string1` and `string2` as equivalent.

##### Example

```
- hello:hi
* goodbye:bye
```

With these rules, "hello" and "hi" will be considered the same, as will "goodbye" and "bye".

##### Known Issue

There is a known issue with the custom rules feature:

When one string is a subset of another, you should put the longer string before the colon and the shorter string after the colon. For example:

```
- goodbye:bye
```

is correct, while

```
- bye:goodbye
```

may not work as expected. Because 'bye' is a subset of 'goodbye', 'goodbye' should be placed before the colon.

We are working on resolving this issue in future updates.

### Live Demo

You can try out Tiko at [https://tiko.kawaro.space](https://tiko.kawaro.space)

### Technology Stack

- Frontend: Flutter (Web)
- Backend: Python Flask
- Deployment: Vercel

### Local Development Setup

#### Prerequisites

- Flutter SDK
- Python 3.8+
- Git

#### Backend Setup

1. Navigate to the backend directory:
   ```
   cd backend
   ```

2. Create a virtual environment:
   ```
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. Install dependencies:
   ```
   pip install -r requirements.txt
   ```

4. Run the Flask server:
   ```
   python app.py
   ```

   The backend server will run on `http://127.0.0.1:5000`.

#### Frontend Setup

1. Navigate to the frontend directory:
   ```
   cd frontend
   ```

2. Get Flutter dependencies:
   ```
   flutter pub get
   ```

3. Run the Flutter web app:
   ```
   flutter run -d chrome
   ```

4. Ensure the API call in `frontend/lib/main.dart` uses the local backend URL:
   ```dart
   final response = await http.post(
     Uri.parse('http://127.0.0.1:5000/api/compare'),
     // ... rest of the code remains unchanged
   );
   ```

### Deployment

This project is configured for deployment on Vercel. The `vercel.json` file in the root directory manages the deployment settings.

To deploy your own instance:

1. Fork this repository
2. Sign up for a Vercel account
3. Connect your forked repository to Vercel
4. Deploy

Note: When deploying to Vercel, make sure to change the API URL to your Vercel deployment URL.

### Contributing

Contributions to Tiko are welcome! Please feel free to submit a Pull Request.

### License

This project is open source and available under the [MIT License](LICENSE).

### Contact

If you have any questions or feedback, please open an issue on the GitHub repository.

---

<a name="中文"></a>
## 中文

Tiko 是一个基于网络的应用程序，允许用户比较两段文本并分析它们的相似度和差异。使用 Flutter 构建前端，Python Flask 构建后端，Tiko 为文本比较任务提供了一个用户友好的界面。

### 功能特点

- 比较两个文本输入
- 忽略空白字符选项
- 忽略标点符号差异选项
- 自定义比较规则
- 相似度百分比显示
- 详细的差异高亮

#### 自定义规则

Tiko 允许用户定义自定义比较规则。这些规则可以用于在比较过程中将某些字符串视为等价。

##### 如何使用自定义规则

1. 在应用程序中启用"使用自定义规则"选项。
2. 点击"编辑自定义规则"打开规则编辑器。
3. 按以下格式输入您的规则：
   ```
   - 字符串1:字符串2
   ```
   或
   ```
   * 字符串1:字符串2
   ```
   每条规则应占一行。

4. 比较时将把`字符串1`和`字符串2`视为等价。

##### 示例

```
- 你好:您好
* 再见:拜拜
```

使用这些规则，"你好"和"您好"将被视为相同，"再见"和"拜拜"也是如此。

##### 已知问题

自定义规则功能存在一个已知问题：

当一个字符串是另一个的子集时，您应该将较长的字符串放在冒号前面，较短的字符串放在冒号后面。例如：

```
- 扣子是只小猫:扣子
```

是正确的，而

```
- 扣子:扣子是只小猫
```

可能无法按预期工作。因为“扣子”是“扣子是只小猫”的子集，所以“扣子是只小猫”应该放在冒号前面。

我们正在努力在未来的更新中解决这个问题。

### 在线演示

您可以在 [https://tiko.kawaro.space](https://tiko.kawaro.space) 体验 Tiko

### 技术栈

- 前端：Flutter (Web)
- 后端：Python Flask
- 部署：Vercel

### 本地开发设置

#### 前提条件

- Flutter SDK
- Python 3.8+
- Git

#### 后端设置

1. 进入后端目录：
   ```
   cd backend
   ```

2. 创建虚拟环境：
   ```
   python -m venv venv
   source venv/bin/activate  # Windows 上使用 `venv\Scripts\activate`
   ```

3. 安装依赖：
   ```
   pip install -r requirements.txt
   ```

4. 运行 Flask 服务器：
   ```
   python app.py
   ```

   后端服务器将在 `http://127.0.0.1:5000` 上运行。

#### 前端设置

1. 进入前端目录：
   ```
   cd frontend
   ```

2. 获取 Flutter 依赖：
   ```
   flutter pub get
   ```

3. 运行 Flutter web 应用：
   ```
   flutter run -d chrome
   ```

4. 确保 `frontend/lib/main.dart` 文件中的 API 调用使用本地后端 URL：
   ```dart
   final response = await http.post(
     Uri.parse('http://127.0.0.1:5000/api/compare'),
     // ... 其余代码保持不变
   );
   ```

### 部署

本项目配置为在 Vercel 上部署。根目录中的 `vercel.json` 文件管理部署设置。

要部署您自己的实例：

1. Fork 这个仓库
2. 注册 Vercel 账户
3. 将您 fork 的仓库连接到 Vercel
4. 部署

注意：在部署到 Vercel 时，请确保将 API URL 更改为您的 Vercel 部署 URL。

### 贡献

欢迎对 Tiko 项目做出贡献！请随时提交 Pull Request。

### 许可证

本项目采用开源 [MIT 许可证](LICENSE)。

### 联系方式

如果您有任何问题或反馈，请在 GitHub 仓库上开一个 issue。