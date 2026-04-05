<template>
  <div class="owner-layout">
    <el-container>
      <el-aside width="200px" class="owner-sidebar">
        <div class="logo">民和社区物业</div>
        <el-menu
          :default-active="activeMenu"
          class="el-menu-vertical-demo"
          @select="handleMenuSelect"
        >
          <el-menu-item index="dashboard">
            <el-icon><HomeFilled /></el-icon>
            <span>首页</span>
          </el-menu-item>
          <el-menu-item index="repair">
            <el-icon><Tools /></el-icon>
            <span>我的报修</span>
          </el-menu-item>
          <el-menu-item index="fee">
            <el-icon><Money /></el-icon>
            <span>我的缴费</span>
          </el-menu-item>
          <el-menu-item index="complaint">
            <el-icon><Warning /></el-icon>
            <span>投诉建议</span>
          </el-menu-item>
          <el-menu-item index="house">
            <el-icon><House /></el-icon>
            <span>房屋信息</span>
          </el-menu-item>
          <el-menu-item index="profile">
            <el-icon><UserFilled /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
      </el-aside>

      <el-container>
        <el-header class="owner-header">
          <div class="header-right">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-dropdown">
                <el-avatar :size="36">
                  业
                </el-avatar>
                <span class="user-info">{{ user?.realName || '业主' }}</span>
                <el-icon class="dropdown-icon"><ArrowDown /></el-icon>
              </div>

              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="logout">
                    退出登录
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </el-header>

        <el-main class="owner-main">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import { HomeFilled, Tools, Money, Warning, House, UserFilled, ArrowDown } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const user = ref(JSON.parse(localStorage.getItem('user') || '{}'))

const activeMenu = computed(() => {
  return route.path.split('/')[2]
})

const handleMenuSelect = (key) => {
  router.push(`/owner/${key}`)
}

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}

const handleCommand = (command) => {
  if (command === 'logout') {
    ElMessageBox.confirm('确定退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
      .then(() => {
        logout()
      })
      .catch(() => {})
  }
}

onMounted(() => {
  if (!localStorage.getItem('token')) {
    router.push('/login')
  }
})
</script>

<style scoped>
.owner-layout {
  height: 100vh;
  overflow: hidden;
  background-color: #f5f7fa;
}

.owner-sidebar {
  background-color: #ffffff;
  color: #333;
  height: 100vh;
  border-right: 1px solid #e4e7ed;
  overflow: hidden;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  font-size: 18px;
  font-weight: bold;
  background-color: #409eff;
  color: #fff;
}

.el-menu-vertical-demo {
  border-right: none;
  background-color: #ffffff;
  min-height: calc(100vh - 60px);
}

.owner-header {
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding-right: 20px;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-dropdown {
  display: flex;
  align-items: center;
  cursor: pointer;
  outline: none;
}

.user-info {
  margin: 0 8px;
  font-size: 14px;
  color: #333;
}

.dropdown-icon {
  font-size: 14px;
  color: #666;
}

.owner-main {
  padding: 20px;
  background-color: #f5f7fa;
  overflow-y: auto;
}
</style>