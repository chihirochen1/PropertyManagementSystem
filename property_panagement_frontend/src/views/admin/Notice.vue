<template>
  <div class="notice-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>公告管理</span>
          <el-button type="primary" size="small" @click="handleAdd">
            <el-icon><Plus /></el-icon>
            新增公告
          </el-button>
        </div>
      </template>
      
      <el-form :inline="true" :model="searchForm" class="mb-4">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入公告标题" style="width: 200px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" style="width: 120px">
            <el-option label="启用" value="1" />
            <el-option label="禁用" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
      
      <el-table :data="noticeList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="content" label="内容" :show-overflow-tooltip="true" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
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
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入公告标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="4"
            placeholder="请输入公告内容"
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
  name: 'Notice',
  setup() {
    const noticeList = ref([]);
    const dialogVisible = ref(false);
    const dialogTitle = ref('新增公告');
    const form = reactive({
      id: '',
      title: '',
      content: '',
      status: 1
    });
    const searchForm = reactive({
      title: '',
      status: ''
    });
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    });
    const rules = {
      title: [{ required: true, message: '请输入公告标题', trigger: 'blur' }],
      content: [{ required: true, message: '请输入公告内容', trigger: 'blur' }]
    };
    const formRef = ref(null);
    
    // 获取公告列表
    const getNoticeList = async () => {
      try {
        const response = await axios.get('/notice/list', {
          params: {
            page: pagination.currentPage,
            size: pagination.pageSize,
            ...searchForm
          }
        });
        if (response.data.code === 200) {
          noticeList.value = response.data.data.list;
          pagination.total = response.data.data.total;
        }
      } catch (error) {
        console.error('获取公告列表失败:', error);
      }
    };
    
    // 新增公告
    const handleAdd = () => {
      dialogTitle.value = '新增公告';
      Object.assign(form, {
        id: '',
        title: '',
        content: '',
        status: 1
      });
      dialogVisible.value = true;
    };
    
    // 编辑公告
    const handleEdit = (row) => {
      dialogTitle.value = '编辑公告';
      Object.assign(form, row);
      dialogVisible.value = true;
    };
    
    // 删除公告
    const handleDelete = async (id) => {
      try {
        const response = await axios.delete(`/notice/delete/${id}`);
        if (response.data.code === 200) {
          getNoticeList();
        }
      } catch (error) {
        console.error('删除公告失败:', error);
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
              response = await axios.put('/notice/update', form);
            } else {
              response = await axios.post('/notice/add', form);
            }
            if (response.data.code === 200) {
              dialogVisible.value = false;
              getNoticeList();
            }
          } catch (error) {
            console.error('保存公告失败:', error);
          }
        }
      });
    };
    
    // 查询
    const handleSearch = () => {
      pagination.currentPage = 1;
      getNoticeList();
    };
    
    // 重置
    const resetForm = () => {
      Object.assign(searchForm, {
        title: '',
        status: ''
      });
      pagination.currentPage = 1;
      getNoticeList();
    };
    
    // 分页
    const handleSizeChange = (size) => {
      pagination.pageSize = size;
      getNoticeList();
    };
    
    const handleCurrentChange = (current) => {
      pagination.currentPage = current;
      getNoticeList();
    };
    
    onMounted(() => {
      getNoticeList();
    });
    
    return {
      noticeList,
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
.notice-container {
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