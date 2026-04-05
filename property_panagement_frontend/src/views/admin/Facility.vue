<template>
  <div class="facility-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>设施管理</span>
          <el-button type="primary" size="small" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增设施
          </el-button>
        </div>
      </template>
      
      <el-form :inline="true" :model="searchForm" class="mb-4">
        <el-form-item label="设施名称">
          <el-input v-model="searchForm.name" placeholder="请输入设施名称" style="width: 200px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" style="width: 120px">
            <el-option label="正常" value="1" />
            <el-option label="故障" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
      
      <el-table :data="facilityList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="设施名称" />
        <el-table-column prop="location" label="位置" />
        <el-table-column prop="description" label="描述" :show-overflow-tooltip="true" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '正常' : '故障' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button size="small" type="danger" @click="handleDelete(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="pagination.currentPage"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>
    
    <!-- 新增/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item label="设施名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入设施名称" />
        </el-form-item>
        <el-form-item label="位置" prop="location">
          <el-input v-model="form.location" placeholder="请输入设施位置" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入设施描述"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" active-value="1" inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
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
  name: 'Facility',
  setup() {
    const facilityList = ref([]);
    const dialogVisible = ref(false);
    const dialogTitle = ref('新增设施');
    const form = reactive({
      id: '',
      name: '',
      location: '',
      description: '',
      status: 1
    });
    const searchForm = reactive({
      name: '',
      status: ''
    });
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    });
    const rules = {
      name: [{ required: true, message: '请输入设施名称', trigger: 'blur' }],
      location: [{ required: true, message: '请输入设施位置', trigger: 'blur' }]
    };
    const formRef = ref(null);
    
    // 获取设施列表
    const getFacilityList = async () => {
      try {
        const response = await axios.get('/facility/list', {
          params: {
            page: pagination.currentPage,
            size: pagination.pageSize,
            ...searchForm
          }
        });
        if (response.data.code === 200) {
          facilityList.value = response.data.data.list;
          pagination.total = response.data.data.total;
        }
      } catch (error) {
        console.error('获取设施列表失败:', error);
      }
    };
    
    // 新增设施
    const handleAdd = () => {
      dialogTitle.value = '新增设施';
      Object.assign(form, {
        id: '',
        name: '',
        location: '',
        description: '',
        status: 1
      });
      dialogVisible.value = true;
    };
    
    // 编辑设施
    const handleEdit = (row) => {
      dialogTitle.value = '编辑设施';
      Object.assign(form, row);
      dialogVisible.value = true;
    };
    
    // 删除设施
    const handleDelete = async (id) => {
      try {
        const response = await axios.delete(`/facility/delete/${id}`);
        if (response.data.code === 200) {
          getFacilityList();
        }
      } catch (error) {
        console.error('删除设施失败:', error);
      }
    };
    
    // 提交表单
    const handleSubmit = async () => {
      if (!formRef.value) return;
      await formRef.value.validate(async (valid) => {
        if (valid) {
          try {
            let response;
            if (form.id) {
              response = await axios.put('/facility/update', form);
            } else {
              response = await axios.post('/facility/add', form);
            }
            if (response.data.code === 200) {
              dialogVisible.value = false;
              getFacilityList();
            }
          } catch (error) {
            console.error('保存设施失败:', error);
          }
        }
      });
    };
    
    // 查询
    const handleSearch = () => {
      pagination.currentPage = 1;
      getFacilityList();
    };
    
    // 重置
    const resetForm = () => {
      Object.assign(searchForm, {
        name: '',
        status: ''
      });
      pagination.currentPage = 1;
      getFacilityList();
    };
    
    // 分页
    const handleSizeChange = (size) => {
      pagination.pageSize = size;
      getFacilityList();
    };
    
    const handleCurrentChange = (current) => {
      pagination.currentPage = current;
      getFacilityList();
    };
    
    onMounted(() => {
      getFacilityList();
    });
    
    return {
      facilityList,
      dialogVisible,
      dialogTitle,
      form,
      searchForm,
      pagination,
      rules,
      formRef,
      handleAdd,
      handleEdit,
      handleDelete,
      handleSubmit,
      handleSearch,
      resetForm,
      handleSizeChange,
      handleCurrentChange,
      Plus
    };
  }
};
</script>

<style scoped>
.facility-container {
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

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>