<template>
  <div class="complaint-container">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <span>投诉建议管理</span>
        </div>
      </template>
      
      <el-form :inline="true" :model="searchForm" class="mb-4">
        <el-form-item label="标题">
          <el-input v-model="searchForm.title" placeholder="请输入投诉标题" style="width: 200px" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" style="width: 120px">
            <el-option label="待处理" value="0" />
            <el-option label="处理中" value="1" />
            <el-option label="已完成" value="2" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
      
      <el-table :data="complaintList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="content" label="内容" :show-overflow-tooltip="true" />
        <el-table-column prop="ownerName" label="业主姓名" width="120" />
        <el-table-column prop="phone" label="联系电话" width="150" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getTagType(scope.row.status)">
              {{ getStatusText(scope.row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column label="操作" width="150">
          <template #default="scope">
            <el-button size="small" @click="handleReply(scope.row)">回复</el-button>
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
    
    <!-- 回复对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
    >
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item label="标题">
          <el-input v-model="form.title" disabled />
        </el-form-item>
        <el-form-item label="内容">
          <el-input
            v-model="form.content"
            type="textarea"
            :rows="4"
            disabled
          />
        </el-form-item>
        <el-form-item label="回复内容" prop="reply">
          <el-input
            v-model="form.reply"
            type="textarea"
            :rows="4"
            placeholder="请输入回复内容"
          />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" placeholder="请选择状态">
            <el-option label="待处理" value="0" />
            <el-option label="处理中" value="1" />
            <el-option label="已完成" value="2" />
          </el-select>
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
import axios from 'axios';

export default {
  name: 'Complaint',
  setup() {
    const complaintList = ref([]);
    const dialogVisible = ref(false);
    const dialogTitle = ref('回复投诉');
    const form = reactive({
      id: '',
      title: '',
      content: '',
      reply: '',
      status: 0
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
      reply: [{ required: true, message: '请输入回复内容', trigger: 'blur' }]
    };
    const formRef = ref(null);
    
    // 获取投诉列表
    const getComplaintList = async () => {
      try {
        const response = await axios.get('/complaint/list', {
          params: {
            page: pagination.currentPage,
            size: pagination.pageSize,
            ...searchForm
          }
        });
        if (response.data.code === 200) {
          complaintList.value = response.data.data.list;
          pagination.total = response.data.data.total;
        }
      } catch (error) {
        console.error('获取投诉列表失败:', error);
      }
    };
    
    // 回复投诉
    const handleReply = (row) => {
      dialogTitle.value = '回复投诉';
      Object.assign(form, row);
      dialogVisible.value = true;
    };
    
    // 删除投诉
    const handleDelete = async (id) => {
      try {
        const response = await axios.delete(`/complaint/delete/${id}`);
        if (response.data.code === 200) {
          getComplaintList();
        }
      } catch (error) {
        console.error('删除投诉失败:', error);
      }
    };
    
    // 提交表单
    const handleSubmit = async () => {
      if (!formRef.value) return;
      await formRef.value.validate(async (valid) => {
        if (valid) {
          try {
            const response = await axios.put('/complaint/update', form);
            if (response.data.code === 200) {
              dialogVisible.value = false;
              getComplaintList();
            }
          } catch (error) {
            console.error('保存回复失败:', error);
          }
        }
      });
    };
    
    // 查询
    const handleSearch = () => {
      pagination.currentPage = 1;
      getComplaintList();
    };
    
    // 重置
    const resetForm = () => {
      Object.assign(searchForm, {
        title: '',
        status: ''
      });
      pagination.currentPage = 1;
      getComplaintList();
    };
    
    // 分页
    const handleSizeChange = (size) => {
      pagination.pageSize = size;
      getComplaintList();
    };
    
    const handleCurrentChange = (current) => {
      pagination.currentPage = current;
      getComplaintList();
    };
    
    // 获取标签类型
    const getTagType = (status) => {
      switch (status) {
        case 0:
          return 'warning';
        case 1:
          return 'info';
        case 2:
          return 'success';
        default:
          return '';
      }
    };
    
    // 获取状态文本
    const getStatusText = (status) => {
      switch (status) {
        case 0:
          return '待处理';
        case 1:
          return '处理中';
        case 2:
          return '已完成';
        default:
          return '';
      }
    };
    
    onMounted(() => {
      getComplaintList();
    });
    
    return {
      complaintList,
      dialogVisible,
      dialogTitle,
      form,
      searchForm,
      pagination,
      rules,
      formRef,
      handleReply,
      handleDelete,
      handleSubmit,
      handleSearch,
      resetForm,
      handleSizeChange,
      handleCurrentChange,
      getTagType,
      getStatusText
    };
  }
};
</script>

<style scoped>
.complaint-container {
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