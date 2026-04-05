<template>
  <div class="login-page">
    <!-- 左侧展示区 -->
    <div class="login-left">
      <div class="left-bg-circle circle-1"></div>
      <div class="left-bg-circle circle-2"></div>
      <div class="left-bg-circle circle-3"></div>

      <div class="left-content">
        <div class="logo-icon">
          <el-icon><HomeFilled /></el-icon>
        </div>
        <h1>民和社区物业管理系统</h1>
        <p class="en-title">MINHE COMMUNITY MANAGEMENT SYSTEM</p>
        <p class="sub-title">连接你我，共建美好家园</p>
      </div>
    </div>

    <!-- 右侧登录区 -->
    <div class="login-right">
      <div class="login-panel">
        <div class="welcome-box">
          <h2>{{ isAdminLogin ? '管理员登录' : '欢迎业主回家' }}</h2>
          <p>请登录您的{{ loginTypeText }}账号</p>
        </div>

        <el-form
          :model="loginForm"
          :rules="loginRules"
          ref="loginFormRef"
          class="login-form"
        >
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              placeholder="请输入用户名"
              size="large"
              clearable
            >
              <template #prefix>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              placeholder="请输入密码"
              size="large"
              show-password
              clearable
              @keyup.enter="login"
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item class="btn-item">
            <el-button type="primary" @click="login" class="login-btn">登录</el-button>
          </el-form-item>
        </el-form>

        <div class="switch-login" @click="switchLogin">
          <span>
            {{ isAdminLogin ? '切换为业主登录' : '切换为管理员登录' }}
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const loginFormRef = ref(null)

const isAdminLogin = computed(() => route.meta.loginType === 'admin')
const loginTypeText = computed(() => (isAdminLogin.value ? '管理员' : '业主'))

const loginForm = reactive({
  username: '',
  password: ''
})

const loginRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const switchLogin = () => {
  if (isAdminLogin.value) {
    router.push('/login/owner')
  } else {
    router.push('/login/admin')
  }
}

const login = async () => {
  try {
    await loginFormRef.value.validate()

    const response = await axios.post('/login', {
      username: loginForm.username,
      password: loginForm.password
    })

    console.log('登录接口返回:', response)
    console.log('登录接口数据:', response.data)

    const res = response.data

    if (res.code === 200) {
      const token = res.data?.token
      const user = res.data?.user
      const isAdminUser = user && user.roleId === 1

      // 当前是管理员登录页，但登录的不是管理员
      if (isAdminLogin.value && !isAdminUser) {
        ElMessage.error('当前是管理员登录入口，请使用管理员账号')
        return
      }

      // 当前是业主登录页，但登录的是管理员
      if (!isAdminLogin.value && isAdminUser) {
        ElMessage.error('当前是业主登录入口，请使用业主账号')
        return
      }

      if (token) {
        localStorage.setItem('token', token)
      }
      if (user) {
        localStorage.setItem('user', JSON.stringify(user))
      }

      ElMessage.success('登录成功')

      if (isAdminUser) {
        router.push('/admin/dashboard')
      } else {
        router.push('/owner/dashboard')
      }
    } else {
      ElMessage.error(res.msg || res.message || '登录失败')
    }
  } catch (error) {
    console.error('登录失败详细信息:', error)
    console.error('error.response:', error.response)
    console.error('error.request:', error.request)
    ElMessage.error('登录失败，请稍后重试')
  }
}
</script>

<style scoped>
.login-page {
  display: flex;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background: #f5f7fa;
}

/* 左侧 */
.login-left {
  position: relative;
  flex: 1;
  min-width: 45%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #1f6bff 0%, #35d0d8 100%);
  overflow: hidden;
}

.left-content {
  position: relative;
  z-index: 2;
  text-align: center;
  color: #fff;
}

 .logo-icon {
  font-size: 90px;
  color: #fff;
}

.left-content h1 {
  margin: 0;
  font-size: 56px;
  font-weight: 700;
  letter-spacing: 2px;
}

.en-title {
  margin-top: 24px;
  font-size: 18px;
  letter-spacing: 2px;
  opacity: 0.95;
}

.sub-title {
  margin-top: 28px;
  font-size: 22px;
  opacity: 0.9;
}

.left-bg-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.08);
  z-index: 1;
}

.circle-1 {
  width: 180px;
  height: 180px;
  top: -40px;
  left: -40px;
}

.circle-2 {
  width: 120px;
  height: 120px;
  top: 180px;
  left: 60px;
}

.circle-3 {
  width: 360px;
  height: 360px;
  right: -100px;
  bottom: -120px;
}

/* 右侧 */
.login-right {
  flex: 1;
  min-width: 55%;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.login-panel {
  width: 420px;
  max-width: 80%;
}

.welcome-box {
  margin-bottom: 40px;
}

.welcome-box h2 {
  margin: 0 0 12px 0;
  font-size: 48px;
  font-weight: 700;
  color: #222;
}

.welcome-box p {
  margin: 0;
  font-size: 20px;
  color: #8c8c8c;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 28px;
}

.login-form :deep(.el-input__wrapper) {
  height: 56px;
  border-radius: 12px;
  box-shadow: 0 0 0 1px #dcdfe6 inset !important;
}

.login-form :deep(.el-input__inner) {
  font-size: 16px;
}

.btn-item {
  margin-top: 8px;
}

.login-btn {
  width: 100%;
  height: 54px;
  border: none;
  border-radius: 12px;
  font-size: 20px;
  font-weight: 600;
  background: linear-gradient(90deg, #1f63ff 0%, #37d0d8 100%);
}

.switch-login {
  margin-top: 6px;
  font-size: 16px;
  color: #8c8c8c;
  cursor: pointer;
}

.switch-login:hover {
  color: #409eff;
}

/* 响应式：屏幕小的时候隐藏左边展示区 */
@media (max-width: 992px) {
  .login-left {
    display: none;
  }

  .login-right {
    min-width: 100%;
  }

  .login-panel {
    width: 88%;
    max-width: 420px;
  }

  .welcome-box h2 {
    font-size: 36px;
  }

  .welcome-box p {
    font-size: 16px;
  }
}
</style>