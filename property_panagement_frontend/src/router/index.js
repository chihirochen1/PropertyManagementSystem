import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    redirect: '/login/owner'
  },
  {
    path: '/login',
    redirect: '/login/owner'
  },
  {
    path: '/login/owner',
    name: 'OwnerLogin',
    component: () => import('../views/Login.vue'),
    meta: {
      loginType: 'owner'
    }
  },
  {
    path: '/login/admin',
    name: 'AdminLogin',
    component: () => import('../views/Login.vue'),
    meta: {
      loginType: 'admin'
    }
  },
  {
    path: '/admin',
    name: 'Admin',
    component: () => import('../views/admin/Layout.vue'),
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',      
        component: () => import('../views/admin/Dashboard.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'owner',
        name: 'Owner',
        component: () => import('../views/admin/Owner.vue'),
        meta: { title: '业主管理' }
      },
      {
        path: 'building',
        name: 'Building',
        component: () => import('../views/admin/Building.vue'),
        meta: { title: '楼栋管理' }
      },
      {
        path: 'house',
        name: 'House',
        component: () => import('../views/admin/House.vue'),
        meta: { title: '房屋管理' }
      },
      {
        path: 'repair',
        name: 'Repair',
        component: () => import('../views/admin/Repair.vue'),
        meta: { title: '报修管理' }
      },
      {
        path: 'fee',
        name: 'Fee',
        component: () => import('../views/admin/Fee.vue'),
        meta: { title: '费用管理' }
      },
      {
        path: 'notice',
        name: 'Notice',
        component: () => import('../views/admin/Notice.vue'),
        meta: { title: '公告管理' }
      },
      {
        path: 'complaint',
        name: 'Complaint',
        component: () => import('../views/admin/Complaint.vue'),
        meta: { title: '投诉建议' }
      },
      {
        path: 'facility',
        name: 'Facility',
        component: () => import('../views/admin/Facility.vue'),
        meta: { title: '设施管理' }
      },
      {
        path: 'parking',
        name: 'Parking',
        component: () => import('../views/admin/Parking.vue'),
        meta: { title: '停车管理' }
      },
      {
        path: 'permission',
        name: 'Permission',
        component: () => import('../views/admin/Permission.vue'),
        meta: { title: '权限管理' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('../views/admin/Profile.vue'),
        meta: { title: '个人中心' }
      }
    ]
  },
  {
    path: '/owner',
    name: 'OwnerHome',
    component: () => import('../views/owner/Layout.vue'),
    children: [
      {
        path: 'dashboard',
        name: 'OwnerDashboard',
        component: () => import('../views/owner/Dashboard.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'repair',
        name: 'OwnerRepair',
        component: () => import('../views/owner/Repair.vue'),
        meta: { title: '我的报修' }
      },
      {
        path: 'fee',
        name: 'OwnerFee',
        component: () => import('../views/owner/Fee.vue'),
        meta: { title: '我的缴费' }
      },
      {
        path: 'complaint',
        name: 'OwnerComplaint',
        component: () => import('../views/owner/Complaint.vue'),
        meta: { title: '投诉建议' }
      },
      {
        path: 'house',
        name: 'OwnerHouse',
        component: () => import('../views/owner/House.vue'),
        meta: { title: '房屋信息' }
      },
      {
        path: 'profile',
        name: 'OwnerProfile',
        component: () => import('../views/owner/Profile.vue'),
        meta: { title: '个人中心' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const userStr = localStorage.getItem('user')
  const user = userStr ? JSON.parse(userStr) : null

  // 动态设置标签页标题
  const systemName = '民和社区物业管理系统'
  document.title = to.meta.title ? `${to.meta.title} - ${systemName}` : systemName

  // 已登录用户访问登录页，直接回各自首页
  if ((to.path === '/login' || to.path === '/login/owner' || to.path === '/login/admin') && token && user) {
    if (user.roleId === 1) {
      next('/admin/dashboard')
    } else {
      next('/owner/dashboard')
    }
    return
  }

  // 未登录访问后台页面，拦截到业主登录页
  if (to.path.startsWith('/admin') || to.path.startsWith('/owner')) {
    if (token) {
      next()
    } else {
      next('/login/owner')
    }
    return
  }

  next()
})

export default router