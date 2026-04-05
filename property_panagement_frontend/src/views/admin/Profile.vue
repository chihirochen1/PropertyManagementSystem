<template>
  <div class="profile-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>个人中心</span>
        </div>
      </template>
      
      <el-tabs v-model="activeTab">
        <el-tab-pane label="个人信息" name="info">
          <el-form :model="userForm" :rules="userRules" ref="userFormRef" label-width="100px">
            <el-form-item label="用户名" prop="username">
              <el-input v-model="userForm.username" disabled />
            </el-form-item>
            <el-form-item label="真实姓名" prop="realName">
              <el-input v-model="userForm.realName" />
            </el-form-item>
            <el-form-item label="联系电话" prop="phone">
              <el-input v-model="userForm.phone" />
            </el-form-item>
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="userForm.email" />
            </el-form-item>
            <el-form-item label="角色">
              <el-input v-model="userForm.roleName" disabled />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdateUser">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        
        <el-tab-pane label="修改密码" name="password">
          <el-form :model="passwordForm" :rules="passwordRules" ref="passwordFormRef" label-width="100px">
            <el-form-item label="原密码" prop="oldPassword">
              <el-input v-model="passwordForm.oldPassword" type="password" />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordForm.newPassword" type="password" />
            </el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input v-model="passwordForm.confirmPassword" type="password" />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleUpdatePassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        
        <el-tab-pane label="操作日志" name="log">
          <el-table :data="logList" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="operation" label="操作" />
            <el-table-column prop="operator" label="操作人" width="120" />
            <el-table-column prop="ip" label="IP地址" width="150" />
            <el-table-column prop="createTime" label="操作时间" width="180" />
          </el-table>
          
          <div class="pagination-container">
            <el-pagination
              v-model:current-page="logPagination.currentPage"
              v-model:page-size="logPagination.pageSize"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              :total="logPagination.total"
              @size-change="handleLogSizeChange"
              @current-change="handleLogCurrentChange"
            />
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import axios from 'axios';

export default {
  name: 'Profile',
  setup() {
    const activeTab = ref('info');
    
    // 个人信息
    const userForm = reactive({
      username: '',
      realName: '',
      phone: '',
      email: '',
      roleName: ''
    });
    const userRules = {
      realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
      phone: [{ required: true, message: '请输入联系电话', trigger: 'blur' }],
      email: [{ required: true, message: '请输入邮箱', trigger: 'blur' }]
    };
    const userFormRef = ref(null);
    
    // 修改密码
    const passwordForm = reactive({
      oldPassword: '',
      newPassword: '',
      confirmPassword: ''
    });
    const passwordRules = {
      oldPassword: [{ required: true, message: '请输入原密码', trigger: 'blur' }],
      newPassword: [{ required: true, message: '请输入新密码', trigger: 'blur' }],
      confirmPassword: [
        { required: true, message: '请确认密码', trigger: 'blur' },
        {
          validator: (rule, value, callback) => {
            if (value !== passwordForm.newPassword) {
              callback(new Error('两次输入的密码不一致'));
            } else {
              callback();
            }
          },
          trigger: 'blur'
        }
      ]
    };
    const passwordFormRef = ref(null);
    
    // 操作日志
    const logList = ref([]);
    const logPagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    });
    
    // 获取用户信息
    const getUserInfo = async () => {
      try {
        // 这里应该调用后端API，暂时使用模拟数据
        userForm.username = 'admin';
        userForm.realName = '管理员';
        userForm.phone = '13800138000';
        userForm.email = 'admin@example.com';
        userForm.roleName = '管理员';
      } catch (error) {
        console.error('获取用户信息失败:', error);
      }
    };
    
    // 获取操作日志
    const getLogList = async () => {
      try {
        // 这里应该调用后端API，暂时使用模拟数据
        logList.value = [
          { id: 1, operation: '登录系统', operator: 'admin', ip: '127.0.0.1', createTime: '2026-04-05 00:00:00' },
          { id: 2, operation: '修改业主信息', operator: 'admin', ip: '127.0.0.1', createTime: '2026-04-04 23:59:59' },
          { id: 3, operation: '发布公告', operator: 'admin', ip: '127.0.0.1', createTime: '2026-04-04 23:58:58' }
        ];
        logPagination.total = logList.value.length;
      } catch (error) {
        console.error('获取操作日志失败:', error);
      }
    };
    
    // 更新用户信息
    const handleUpdateUser = async () => {
      if (!userFormRef.value) return;
      await userFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            // 这里应该调用后端API
            console.log('更新用户信息:', userForm);
            // 模拟成功
            alert('更新成功');
          } catch (error) {
            console.error('更新用户信息失败:', error);
          }
        }
      });
    };
    
    // 更新密码
    const handleUpdatePassword = async () => {
      if (!passwordFormRef.value) return;
      await passwordFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            // 这里应该调用后端API
            console.log('修改密码:', passwordForm);
            // 模拟成功
            alert('修改密码成功');
            // 重置表单
            Object.assign(passwordForm, {
              oldPassword: '',
              newPassword: '',
              confirmPassword: ''
            });
          } catch (error) {
            console.error('修改密码失败:', error);
          }
        }
      });
    };
    
    // 分页日志
    const handleLogSizeChange = (size) => {
      logPagination.pageSize = size;
      getLogList();
    };
    
    const handleLogCurrentChange = (current) => {
      logPagination.currentPage = current;
      getLogList();
    };
    
    onMounted(() => {
      getUserInfo();
      getLogList();
    });
    
    return {
      activeTab,
      // 个人信息
      userForm,
      userRules,
      userFormRef,
      handleUpdateUser,
      // 修改密码
      passwordForm,
      passwordRules,
      passwordFormRef,
      handleUpdatePassword,
      // 操作日志
      logList,
      logPagination,
      handleLogSizeChange,
      handleLogCurrentChange
    };
  }
};
</script>

<style scoped>
.profile-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>