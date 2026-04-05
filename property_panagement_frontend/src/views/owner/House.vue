<template>
  <div class="owner-house">
    <el-card>
      <template #header>
        <div class="card-header">
          <span>房屋信息</span>
        </div>
      </template>
      <el-descriptions :column="1" border>
        <el-descriptions-item label="房屋ID">{{ houseInfo.id }}</el-descriptions-item>
        <el-descriptions-item label="楼栋">{{ houseInfo.buildingName }}</el-descriptions-item>
        <el-descriptions-item label="单元">{{ houseInfo.unit }}</el-descriptions-item>
        <el-descriptions-item label="房间号">{{ houseInfo.roomNumber }}</el-descriptions-item>
        <el-descriptions-item label="户型">{{ houseInfo.houseType }}</el-descriptions-item>
        <el-descriptions-item label="面积">{{ houseInfo.area }}㎡</el-descriptions-item>
        <el-descriptions-item label="状态">{{ houseInfo.status === 1 ? '已入住' : '空闲' }}</el-descriptions-item>
        <el-descriptions-item label="描述">{{ houseInfo.description }}</el-descriptions-item>
      </el-descriptions>

      <el-card class="family-card" style="margin-top: 20px;">
        <template #header>
          <div class="card-header">
            <span>家庭成员</span>
            <el-button type="primary" @click="openAddFamilyDialog">添加成员</el-button>
          </div>
        </template>
        <el-table :data="familyList" style="width: 100%">
          <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="name" label="姓名" />
          <el-table-column prop="relation" label="关系" />
          <el-table-column prop="idCard" label="身份证号" />
          <el-table-column prop="phone" label="手机号" />
          <el-table-column label="操作" width="200">
            <template #default="scope">
              <el-button type="primary" size="small" @click="editFamily(scope.row)">编辑</el-button>
              <el-button type="danger" size="small" @click="deleteFamily(scope.row.id)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </el-card>

    <!-- 添加/编辑家庭成员对话框 -->
    <el-dialog v-model="familyDialogVisible" :title="familyDialogTitle">
      <el-form :model="familyForm" :rules="familyRules" ref="familyFormRef" label-width="100px">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="familyForm.name" placeholder="请输入姓名"></el-input>
        </el-form-item>
        <el-form-item label="关系" prop="relation">
          <el-input v-model="familyForm.relation" placeholder="请输入关系"></el-input>
        </el-form-item>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="familyForm.idCard" placeholder="请输入身份证号"></el-input>
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="familyForm.phone" placeholder="请输入手机号"></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="familyDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitFamily">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'

const houseInfo = ref({
  id: 1,
  buildingName: '1号楼',
  unit: '1单元',
  roomNumber: '101',
  houseType: '两室一厅',
  area: 80.5,
  status: 1,
  description: '1号楼1单元101室'
})

const familyList = ref([
  {
    id: 1,
    name: '张三',
    relation: '本人',
    idCard: '110101199001011234',
    phone: '13812345678'
  },
  {
    id: 2,
    name: '李四',
    relation: '配偶',
    idCard: '110101199002022345',
    phone: '13912345678'
  }
])

const familyDialogVisible = ref(false)
const familyDialogTitle = ref('添加家庭成员')
const familyFormRef = ref(null)

const familyForm = reactive({
  id: '',
  name: '',
  relation: '',
  idCard: '',
  phone: ''
})

const familyRules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  relation: [{ required: true, message: '请输入关系', trigger: 'blur' }],
  idCard: [{ required: true, message: '请输入身份证号', trigger: 'blur' }],
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }]
}

onMounted(() => {
  // 实际项目中这里会调用API获取数据
})

const openAddFamilyDialog = () => {
  familyDialogTitle.value = '添加家庭成员'
  Object.assign(familyForm, {
    id: '',
    name: '',
    relation: '',
    idCard: '',
    phone: ''
  })
  familyDialogVisible.value = true
}

const editFamily = (row) => {
  familyDialogTitle.value = '编辑家庭成员'
  Object.assign(familyForm, row)
  familyDialogVisible.value = true
}

const submitFamily = async () => {
  await familyFormRef.value.validate()
  try {
    // 实际项目中这里会调用API提交数据
    ElMessage.success('操作成功')
    familyDialogVisible.value = false
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const deleteFamily = (id) => {
  // 实际项目中这里会调用API删除数据
  ElMessage.success('删除成功')
}
</script>

<style scoped>
.owner-house {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.family-card {
  margin-top: 20px;
}
</style>