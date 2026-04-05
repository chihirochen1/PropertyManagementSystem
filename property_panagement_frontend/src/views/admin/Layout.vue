<template>
  <div class="admin-layout">
    <el-container>
      <el-aside width="200px" class="admin-sidebar">
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
          <el-menu-item index="owner">
            <el-icon><User /></el-icon>
            <span>业主管理</span>
          </el-menu-item>
          <el-menu-item index="building">
            <el-icon><OfficeBuilding /></el-icon>
            <span>楼栋管理</span>
          </el-menu-item>
          <el-menu-item index="house">
            <el-icon><House /></el-icon>
            <span>房屋管理</span>
          </el-menu-item>
          <el-menu-item index="repair">
            <el-icon><Tools /></el-icon>
            <span>报修管理</span>
          </el-menu-item>
          <el-menu-item index="fee">
            <el-icon><Money /></el-icon>
            <span>费用管理</span>
          </el-menu-item>
          <el-menu-item index="notice">
            <el-icon><Message /></el-icon>
            <span>公告管理</span>
          </el-menu-item>
          <el-menu-item index="complaint">
            <el-icon><Warning /></el-icon>
            <span>投诉建议</span>
          </el-menu-item>
          <el-menu-item index="facility">
            <el-icon><Setting /></el-icon>
            <span>设施管理</span>
          </el-menu-item>
          <el-menu-item index="parking">
            <el-icon><Van /></el-icon>
            <span>停车管理</span>
          </el-menu-item>
          <el-menu-item index="permission">
            <el-icon><Lock /></el-icon>
            <span>权限管理</span>
          </el-menu-item>
          <el-menu-item index="profile">
            <el-icon><UserFilled /></el-icon>
            <span>个人中心</span>
          </el-menu-item>
        </el-menu>
      </el-aside>
      <el-container>
        <el-header class="admin-header">
          <div class="header-right">
            <span class="user-info">{{ user.realName }}</span>
            <el-button link type="primary" @click="logout">退出登录</el-button>
          </div>
        </el-header>
        <el-main class="admin-main">
          <router-view />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { HomeFilled, User, OfficeBuilding, House, Tools, Money, Message, Warning, Setting, Van, Lock, UserFilled } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const user = ref(JSON.parse(localStorage.getItem('user')))

const activeMenu = computed(() => {
  return route.path.split('/')[2]
})

const handleMenuSelect = (key) => {
  router.push(`/admin/${key}`)
}

const logout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('user')
  router.push('/login')
}

onMounted(() => {
  if (!localStorage.getItem('token')) {
    router.push('/login')
  }
})
</script>

<style scoped>
.admin-layout {
  height: 100vh;
  overflow: hidden;
}

.admin-sidebar {
  /* background-color: #001529; */
  color: #fff;
}

.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  font-size: 18px;
  font-weight: bold;
  background-color: #0d7ae0;
  color: #fff;
}

.el-menu-vertical-demo {
  border-right: none;
}

.admin-header {
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: flex;
  justify-content: flex-end;
  align-items: center;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.user-info {
  font-size: 14px;
  color: #333;
}

.admin-main {
  padding: 20px;
  background-color: #f5f7fa;
  overflow-y: auto;
}
</style>