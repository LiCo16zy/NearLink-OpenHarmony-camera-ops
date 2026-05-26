# 04 Android APP 骨架搭建

> **目标：** 创建 Android APP 项目，搭建主界面框架：4 个主要页面的空壳 + 页面间跳转。
> **时间：** 第2周（5.25 - 5.31），建议在完成第1周环境搭建后进行。
> **最终检验标准：** APP 在手机上安装后，能通过底部导航栏切换 4 个页面，每个页面显示对应的标题文字。

---

## 一、APP 总览——最终长什么样

你的移动端 APP **CameraOAM** 最终有 4 个主要页面：

```
底部导航栏
  ├── 📡 发现页（Discovery）   → 扫描并发现附近的星闪摄像机
  ├── 🔗 连接页（Connection）  → 显示已连接设备信息、信号强度
  ├── 📺 预览页（Preview）    → 实时显示摄像机画面（核心页面）
  └── ⚙️ 控制页（Control）    → 云台控制、参数配置、运维操作
```

**本周你只需要搭空壳：** 4 个页面能显示文字标题、能通过底部导航栏切换即可。不要试图在本周实现任何实际功能。

> 💡 **为什么先搭空壳？**
> 这叫"骨架优先"策略——先把 APP 的结构定好，后面每一块功能往里填。比先写一个完整页面再拆分成 4 个页面要快得多。而且当你拿到硬件后，可以直接测试页面间的数据传递，不用现搭 UI。

---

## 二、操作步骤

### 第1步：在 Android Studio 中创建项目

1. 打开 Android Studio，点击 **New Project**
2. 选择 **Empty Views Activity**
3. 配置如下：

| 字段 | 填写内容 |
|------|---------|
| Name | `CameraOAM` |
| Package name | `com.camera.oam` |
| Language | **Kotlin** |
| Minimum SDK | **API 26 (Android 8.0)** |
| Build configuration language | **Gradle Kotlin DSL** |

4. 点击 **Finish**，等待 Gradle 构建完成

---

### 第2步：引入底部导航依赖

打开 `app/build.gradle.kts`（项目根目录 → `app` → `build.gradle.kts`），在 `dependencies {}` 块中添加：

```kotlin
dependencies {
    // ... 原来的依赖（implementation 开头的）保留不动 ...

    // 添加底部导航栏库
    implementation("androidx.navigation:navigation-fragment-ktx:2.7.7")
    implementation("androidx.navigation:navigation-ui-ktx:2.7.7")
}
```

> 添加后，点击 Android Studio 右上角的 **Sync Now** 按钮，等待同步完成。

> 💡 **知识卡片：为什么用 Navigation 组件？**
> Android 官方推荐的页面切换方案。它把"页面跳转"这件事变成了可视化配置——你画一个"导航图"，告诉系统哪个页面连到哪个页面，代码里调 `navigate()` 就能跳转。比手动管理 Fragment 的添加/替换要简单很多。

---

### 第3步：创建 4 个 Fragment

Fragment 可以理解为"页面片段"，一个 Activity 里面可以放多个 Fragment，通过导航栏切换。

依次创建 4 个 Fragment：

1. 在 Android Studio 左侧项目面板中，右键点击 `com.camera.oam` → **New** → **Fragment** → **Fragment (Blank)**
2. 按下面的表格创建：

| Fragment 名称          | Fragment 布局文件名        | 菜单标题 |
| -------------------- | --------------------- | ---- |
| `DiscoveryFragment`  | `fragment_discovery`  | 发现设备 |
| `ConnectionFragment` | `fragment_connection` | 连接状态 |
| `PreviewFragment`    | `fragment_preview`    | 视频预览 |
| `ControlFragment`    | `fragment_control`    | 设备控制 |

> 创建时 Android Studio 会自动生成两个文件：
> - `DiscoveryFragment.kt`（代码文件）
> - `fragment_discovery.xml`（布局文件，放在 `res/layout/` 目录下）

**以 DiscoveryFragment 为例，修改布局文件。**

打开 `fragment_discovery.xml`（在 `res/layout/` 目录下），把内容替换成：

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <TextView
        android:id="@+id/text_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="发现设备"
        android:textSize="24sp"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

其他 3 个 Fragment 的布局文件做同样的事，只把 `android:text` 改成对应的标题：
- ConnectionFragment → `"连接状态"`
- PreviewFragment → `"视频预览"`
- ControlFragment → `"设备控制"`

---

### 第4步：创建底部导航菜单资源

1. 在 `res` 目录上右键 → **New** → **Android Resource Directory**
2. Resource type 选择 `menu`，点击 OK

在 `res/menu/` 目录下创建文件 `bottom_nav_menu.xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:id="@+id/nav_discovery"
        android:icon="@android:drawable/ic_menu_search"
        android:title="发现" />
    <item
        android:id="@+id/nav_connection"
        android:icon="@android:drawable/ic_menu_info_details"
        android:title="连接" />
    <item
        android:id="@+id/nav_preview"
        android:icon="@android:drawable/ic_menu_camera"
        android:title="预览" />
    <item
        android:id="@+id/nav_control"
        android:icon="@android:drawable/ic_menu_manage"
        android:title="控制" />
</menu>
```

> 💡 **知识卡片：这里用的是系统内置图标**
> `@android:drawable/ic_menu_xxx` 是 Android 系统自带的图标，不需要额外引入图标库。后面你可以替换成更好看的设计图标（Material Icons），但现在先用系统的，省事。

---

### 第5步：创建导航图

1. 在 `res` 目录上右键 → **New** → **Android Resource Directory**
2. Resource type 选择 `navigation`，点击 OK

在 `res/navigation/` 目录下创建文件 `nav_graph.xml`：

```xml
<?xml version="1.0" encoding="utf-8"?>
<navigation xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/nav_graph"
    app:startDestination="@id/nav_discovery">

    <fragment
        android:id="@+id/nav_discovery"
        android:name="com.camera.oam.DiscoveryFragment"
        android:label="发现设备"
        tools:layout="@layout/fragment_discovery" />
    <fragment
        android:id="@+id/nav_connection"
        android:name="com.camera.oam.ConnectionFragment"
        android:label="连接状态"
        tools:layout="@layout/fragment_connection" />
    <fragment
        android:id="@+id/nav_preview"
        android:name="com.camera.oam.PreviewFragment"
        android:label="视频预览"
        tools:layout="@layout/fragment_preview" />
    <fragment
        android:id="@+id/nav_control"
        android:name="com.camera.oam.ControlFragment"
        android:label="设备控制"
        tools:layout="@layout/fragment_control" />
</navigation>
```

> 注意 `app:startDestination="@id/nav_discovery"` —— 这个指定了 APP 启动时第一个显示的是"发现设备"页面。

---

### 第6步：修改主 Activity

打开 `MainActivity.kt`，替换成以下内容：

```kotlin
package com.camera.oam

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.navigation.fragment.NavHostFragment
import androidx.navigation.ui.setupWithNavController
import com.camera.oam.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    // ViewBinding：不用 findViewById，直接通过 binding.xxx 访问控件
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 启用 ViewBinding
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 找到 NavHostFragment（负责 Fragment 切换的容器）
        val navHostFragment = supportFragmentManager
            .findFragmentById(R.id.nav_host_fragment) as NavHostFragment
        val navController = navHostFragment.navController

        // 把底部导航栏和导航控制器绑定
        // 这样点击底部按钮就会自动切换 Fragment
        binding.bottomNavigation.setupWithNavController(navController)
    }
}
```

---

### 第7步：修改主 Activity 的布局

打开 `res/layout/activity_main.xml`，替换成：

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <!-- 这是 Fragment 切换的容器 -->
    <androidx.fragment.app.FragmentContainerView
        android:id="@+id/nav_host_fragment"
        android:name="androidx.navigation.fragment.NavHostFragment"
        android:layout_width="0dp"
        android:layout_height="0dp"
        app:defaultNavHost="true"
        app:navGraph="@navigation/nav_graph"
        app:layout_constraintTop_toTopOf="parent"
        app:layout_constraintBottom_toTopOf="@id/bottom_navigation"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

    <!-- 底部导航栏 -->
    <com.google.android.material.bottomnavigation.BottomNavigationView
        android:id="@+id/bottom_navigation"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        app:menu="@menu/bottom_nav_menu"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintEnd_toEndOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

---

### 第8步：用手机运行测试

1. 用 USB 数据线把你的 Android 手机连接到电脑
2. 手机上开启 **开发者选项** 和 **USB 调试**：
   - 设置 → 关于手机 → 连续点击"版本号"7次 → 返回"设置"出现"开发者选项"
   - 进入开发者选项 → 开启 USB 调试
3. 在 Android Studio 顶部工具栏的设备下拉菜单中选择你的手机
4. 点击绿色 ▶ 按钮运行

> **预期结果：** APP 安装在手机上，底部有 4 个按钮（发现/连接/预览/控制），点击不同按钮，上面内容区域切换显示对应的标题文字。

---

## 三、遇到的常见问题

### ❌ "Gradle 同步失败"
**原因：** 网络问题无法下载 Gradle 依赖。

**解决：** 设置国内镜像。在项目根目录的 `settings.gradle.kts` 中修改：

```kotlin
pluginManagement {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        google()
        mavenCentral()
    }
}
```

### ❌ "BottomNavigationView 找不到"
**原因：** 没有引入 Material 组件库。

**解决：** 在 `app/build.gradle.kts` 的 `dependencies` 中添加：

```kotlin
implementation("com.google.android.material:material:1.12.0")
```

### ❌ "The project is using an incompatible version of AGP"
**原因：** Android Studio 版本和 Gradle 插件版本不匹配。

**解决：** 打开 `build.gradle.kts`（项目根目录），把 AGP 版本改成和你的 Android Studio 匹配的版本。Android Studio Ladybug 用 8.7.x，Koala 用 8.5.x。

---

## 四、本周检验清单

- [ ] Android Studio 项目创建成功，Gradle 同步通过
- [ ] 4 个 Fragment 创建完成，每个有对应的布局文件
- [ ] 底部导航菜单（4 个 item）创建完成
- [ ] 导航图（nav_graph.xml）创建完成
- [ ] `activity_main.xml` 中包含了 FragmentContainerView 和 BottomNavigationView
- [ ] `MainActivity.kt` 中完成了 Navigation 绑定
- [ ] **APP 能在手机上运行**，4个页面通过底部导航栏切换

**如果你卡住了，把 Android Studio 的错误信息截图或复制发给我，我帮你分析。**

---

## 五、下一阶段预告

第3周（6.1 - 6.7）我们会在第2周骨架的基础上：
- 设计并实现"数据模拟层"——模拟星闪通信（APP 在没有硬件时也能调试）
- 在"发现页"实现模拟设备扫描功能
- 在"连接页"显示模拟连接状态
