<template>
  <div class="permission-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>权限管理</span>
        </div>
      </template>
      
      <el-tabs v-model="activeTab">
        <el-tab-pane label="角色管理" name="role">
          <div class="mb-4">
            <el-button type="primary" size="small" @click="handleAddRole">
              <el-icon><Plus /></el-icon>
              新增角色
            </el-button>
          </div>
          
          <el-table :data="roleList" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="name" label="角色名称" />
            <el-table-column prop="description" label="描述" :show-overflow-tooltip="true" />
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button size="small" @click="handleEditRole(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" @click="handleDeleteRole(scope.row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        
        <el-tab-pane label="菜单管理" name="menu">
          <div class="mb-4">
            <el-button type="primary" size="small" @click="handleAddMenu">
              <el-icon><Plus /></el-icon>
              新增菜单
            </el-button>
          </div>
          
          <el-table :data="menuList" style="width: 100%">
            <el-table-column prop="id" label="ID" width="80" />
            <el-table-column prop="name" label="菜单名称" />
            <el-table-column prop="path" label="路径" />
            <el-table-column prop="icon" label="图标" />
            <el-table-column label="操作" width="150">
              <template #default="scope">
                <el-button size="small" @click="handleEditMenu(scope.row)">编辑</el-button>
                <el-button size="small" type="danger" @click="handleDeleteMenu(scope.row.id)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </el-card>
    
    <!-- 角色新增/编辑对话框 -->
    <el-dialog
      v-model="roleDialogVisible"
      :title="roleDialogTitle"
      width="500px"
    >
      <el-form :model="roleForm" :rules="roleRules" ref="roleFormRef">
        <el-form-item label="角色名称" prop="name">
          <el-input v-model="roleForm.name" placeholder="请输入角色名称" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="roleForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入角色描述"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="roleDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmitRole">确定</el-button>
        </span>
      </template>
    </el-dialog>
    
    <!-- 菜单新增/编辑对话框 -->
    <el-dialog
      v-model="menuDialogVisible"
      :title="menuDialogTitle"
      width="500px"
    >
      <el-form :model="menuForm" :rules="menuRules" ref="menuFormRef">
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="menuForm.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="路径" prop="path">
          <el-input v-model="menuForm.path" placeholder="请输入路径" />
        </el-form-item>
        <el-form-item label="图标" prop="icon">
          <el-input v-model="menuForm.icon" placeholder="请输入图标名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="menuDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmitMenu">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue';
import { Plus } from '@element-plus/icons-vue';
import axios from 'axios';

export default {
  name: 'Permission',
  setup() {
    const activeTab = ref('role');
    
    // 角色管理
    const roleList = ref([]);
    const roleDialogVisible = ref(false);
    const roleDialogTitle = ref('新增角色');
    const roleForm = reactive({
      id: '',
      name: '',
      description: ''
    });
    const roleRules = {
      name: [{ required: true, message: '请输入角色名称', trigger: 'blur' }]
    };
    const roleFormRef = ref(null);
    
    // 菜单管理
    const menuList = ref([]);
    const menuDialogVisible = ref(false);
    const menuDialogTitle = ref('新增菜单');
    const menuForm = reactive({
      id: '',
      name: '',
      path: '',
      icon: ''
    });
    const menuRules = {
      name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
      path: [{ required: true, message: '请输入路径', trigger: 'blur' }]
    };
    const menuFormRef = ref(null);
    
    // 获取角色列表
    const getRoleList = async () => {
      try {
        // 这里应该调用后端API，暂时使用模拟数据
        roleList.value = [
          { id: 1, name: '管理员', description: '系统管理员' },
          { id: 2, name: '业主', description: '小区业主' }
        ];
      } catch (error) {
        console.error('获取角色列表失败:', error);
      }
    };
    
    // 获取菜单列表
    const getMenuList = async () => {
      try {
        // 这里应该调用后端API，暂时使用模拟数据
        menuList.value = [
          { id: 1, name: '首页', path: '/admin/dashboard', icon: 'HomeFilled' },
          { id: 2, name: '业主管理', path: '/admin/owner', icon: 'User' },
          { id: 3, name: '楼栋管理', path: '/admin/building', icon: 'OfficeBuilding' },
          { id: 4, name: '房屋管理', path: '/admin/house', icon: 'House' },
          { id: 5, name: '报修管理', path: '/admin/repair', icon: 'Tools' },
          { id: 6, name: '费用管理', path: '/admin/fee', icon: 'Money' },
          { id: 7, name: '公告管理', path: '/admin/notice', icon: 'Message' },
          { id: 8, name: '投诉建议', path: '/admin/complaint', icon: 'Warning' },
          { id: 9, name: '设施管理', path: '/admin/facility', icon: 'Setting' },
          { id: 10, name: '停车管理', path: '/admin/parking', icon: 'Van' },
          { id: 11, name: '权限管理', path: '/admin/permission', icon: 'Lock' },
          { id: 12, name: '个人中心', path: '/admin/profile', icon: 'UserFilled' }
        ];
      } catch (error) {
        console.error('获取菜单列表失败:', error);
      }
    };
    
    // 新增角色
    const handleAddRole = () => {
      roleDialogTitle.value = '新增角色';
      Object.assign(roleForm, {
        id: '',
        name: '',
        description: ''
      });
      roleDialogVisible.value = true;
    };
    
    // 编辑角色
    const handleEditRole = (row) => {
      roleDialogTitle.value = '编辑角色';
      Object.assign(roleForm, row);
      roleDialogVisible.value = true;
    };
    
    // 删除角色
    const handleDeleteRole = async (id) => {
      try {
        // 这里应该调用后端API
        const index = roleList.value.findIndex(item => item.id === id);
        if (index !== -1) {
          roleList.value.splice(index, 1);
        }
      } catch (error) {
        console.error('删除角色失败:', error);
      }
    };
    
    // 提交角色表单
    const handleSubmitRole = async () => {
      if (!roleFormRef.value) return;
      await roleFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            // 这里应该调用后端API
            if (roleForm.id) {
              const index = roleList.value.findIndex(item => item.id === roleForm.id);
              if (index !== -1) {
                roleList.value[index] = { ...roleForm };
              }
            } else {
              const newRole = {
                id: roleList.value.length + 1,
                ...roleForm
              };
              roleList.value.push(newRole);
            }
            roleDialogVisible.value = false;
          } catch (error) {
            console.error('保存角色失败:', error);
          }
        }
      });
    };
    
    // 新增菜单
    const handleAddMenu = () => {
      menuDialogTitle.value = '新增菜单';
      Object.assign(menuForm, {
        id: '',
        name: '',
        path: '',
        icon: ''
      });
      menuDialogVisible.value = true;
    };
    
    // 编辑菜单
    const handleEditMenu = (row) => {
      menuDialogTitle.value = '编辑菜单';
      Object.assign(menuForm, row);
      menuDialogVisible.value = true;
    };
    
    // 删除菜单
    const handleDeleteMenu = async (id) => {
      try {
        // 这里应该调用后端API
        const index = menuList.value.findIndex(item => item.id === id);
        if (index !== -1) {
          menuList.value.splice(index, 1);
        }
      } catch (error) {
        console.error('删除菜单失败:', error);
      }
    };
    
    // 提交菜单表单
    const handleSubmitMenu = async () => {
      if (!menuFormRef.value) return;
      await menuFormRef.value.validate(async (valid) => {
        if (valid) {
          try {
            // 这里应该调用后端API
            if (menuForm.id) {
              const index = menuList.value.findIndex(item => item.id === menuForm.id);
              if (index !== -1) {
                menuList.value[index] = { ...menuForm };
              }
            } else {
              const newMenu = {
                id: menuList.value.length + 1,
                ...menuForm
              };
              menuList.value.push(newMenu);
            }
            menuDialogVisible.value = false;
          } catch (error) {
            console.error('保存菜单失败:', error);
          }
        }
      });
    };
    
    onMounted(() => {
      getRoleList();
      getMenuList();
    });
    
    return {
      activeTab,
      // 角色管理
      roleList,
      roleDialogVisible,
      roleDialogTitle,
      roleForm,
      roleRules,
      roleFormRef,
      handleAddRole,
      handleEditRole,
      handleDeleteRole,
      handleSubmitRole,
      // 菜单管理
      menuList,
      menuDialogVisible,
      menuDialogTitle,
      menuForm,
      menuRules,
      menuFormRef,
      handleAddMenu,
      handleEditMenu,
      handleDeleteMenu,
      handleSubmitMenu,
      Plus
    };
  }
};
</script>

<style scoped>
.permission-container {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>