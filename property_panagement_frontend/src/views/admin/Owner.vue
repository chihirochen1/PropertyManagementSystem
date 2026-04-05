<template>
  <div class="owner-management">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>业主管理</span>
          <el-button type="primary" @click="openAddDialog">添加业主</el-button>
        </div>
      </template>
      <el-table :data="ownerList" style="width: 100%">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="姓名" />
        <el-table-column prop="idCard" label="身份证号" />
        <el-table-column prop="phone" label="手机号" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="houseId" label="房屋ID" />
        <el-table-column prop="status" label="状态">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '正常' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button type="primary" size="small" @click="openEditDialog(scope.row)">编辑</el-button>
            <el-button type="danger" size="small" @click="deleteOwner(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 添加/编辑业主对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle">
      <el-form :model="ownerForm" :rules="ownerRules" ref="ownerFormRef" label-width="100px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="ownerForm.name" placeholder="请输入姓名"></el-input>
        </el-form-item>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="ownerForm.idCard" placeholder="请输入身份证号"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="ownerForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="ownerForm.email" placeholder="请输入邮箱"></el-input>
        </el-form-item>
        <el-form-item label="房屋ID" prop="houseId">
          <el-input v-model="ownerForm.houseId" type="number" placeholder="请输入房屋ID"></el-input>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="ownerForm.status" placeholder="请选择状态">
            <el-option label="正常" value="1"></el-option>
            <el-option label="禁用" value="0"></el-option>
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'

const ownerList = ref([])
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('添加业主')
const ownerFormRef = ref(null)

const ownerForm = reactive({
  id: '',
  name: '',
  idCard: '',
  phone: '',
  email: '',
  houseId: '',
  status: 1
})

const ownerRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  idCard: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }],
  houseId: [{ required: true, message: '请输入房屋ID', trigger: 'blur' }]
}

onMounted(() => {
  getOwnerList()
})

const getOwnerList = async () => {
  try {
    const response = await axios.get('/owner/list', {
      params: {
        page: currentPage.value,
        size: pageSize.value
      }
    });
    if (response.data.code === 200) {
      ownerList.value = response.data.data.list;
      total.value = response.data.data.total;
    }
  } catch (error) {
    ElMessage.error('获取业主列表失败');
  }
}

const handleSizeChange = (size) => {
  pageSize.value = size
  getOwnerList()
}

const handleCurrentChange = (current) => {
  currentPage.value = current
  getOwnerList()
}

const openAddDialog = () => {
  dialogTitle.value = '添加业主'
  Object.assign(ownerForm, {
    id: '',
    name: '',
    idCard: '',
    phone: '',
    email: '',
    houseId: '',
    status: 1
  })
  dialogVisible.value = true
}

const openEditDialog = (row) => {
  dialogTitle.value = '编辑业主'
  Object.assign(ownerForm, row)
  dialogVisible.value = true
}

const submitForm = async () => {
  await ownerFormRef.value.validate()
  try {
    let response
    if (ownerForm.id) {
      response = await axios.put('/owner/update', ownerForm)
    } else {
      response = await axios.post('/owner/add', ownerForm)
    }
    if (response.data.code === 200) {
      ElMessage.success('操作成功')
      dialogVisible.value = false
      getOwnerList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteOwner = async (id) => {
  try {
    const response = await axios.delete(`/owner/delete/${id}`)
    if (response.data.code === 200) {
      ElMessage.success('删除成功')
      getOwnerList()
    } else {
      ElMessage.error(response.data.message)
    }
  } catch (error) {
    ElMessage.error('删除失败')
  }
}
</script>

<style scoped>
.owner-management {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>