<template lang="html">
  <div class = "table-responsive table-hover ">
  <div class="tab-content">
    <div v-show="currentTab === 0">
      <table class="table">
        <thead>
        <tr>
          <th>ID</th>
          <th>Title</th>
          <th>Course</th>
          <th>Instructor</th>
          <th>Человек</th>
          <th>Начало</th>
          <th>Конец</th>
          <th>Действия</th>
        </tr>
        </thead>
        <tbody>
        <tr v-if="groups.length && courses[group.course_id].visible && new Date(group.start) < new Date() &&
          new Date(group.end) > new Date()" v-for="group in filteredGroups" :key="group.id"
            :group="group" @dblclick="editGroup(group)">
          <td>
            {{ group.id }}
          </td>
          <td width = "70px">
            <div v-show="group != editedGroup">
              <router-link :to="`/admin/groups/${group.slug}`">
                {{ group.title }}
              </router-link>
            </div>
            <div class="form-group" v-show="group == editedGroup"
                 v-on:blur="group.editedGroup=false; $emit('update')">
              <input v-model.lazy="group.title" class="form-control">
            </div>
          </td>
          <td>
            <div v-show="group != editedGroup">
              {{ courses[group.course_id].title }}
            </div>
            <div class="form-group" v-show="group == editedGroup"
                 v-on:blur="group.editedGroup=false; $emit('update')">
              <select v-model="group.course_id" class="form-control">
                <option v-if="course.visible" v-for="course in courses" v-bind:value="course.id" v-bind:key="course.id">{{
                  course.title }}
                </option>
              </select>
            </div>
          </td>
          <td>
            <div v-show="group != editedGroup">
              {{ users[group.instructor_id].name }}
            </div>
            <div class="form-group" v-show="group == editedGroup"
                 v-on:blur="group.editedGroup=false; $emit('update')">
              <select v-model="group.instructor_id" class="form-control">
                <option v-for="instructor in instructors" v-bind:value="instructor.id" v-bind:key="instructor.id">{{
                  instructor.name }}
                </option>
              </select>
            </div>
          </td>
          <td>
            {{ enrollments[group.slug] }}
          </td>
          <td>
            <div v-show="group != editedGroup">
              {{ group.start | formatDate }}
            </div>
            <div class="form-group" v-show="group == editedGroup"
                 v-on:blur="group.editedGroup=false; $emit('update')">
              <datepicker
                v-model.lazy="group.start">
              </datepicker>
            </div>
          </td>
          <td>
            <div v-show="group != editedGroup">
              {{ group.end | formatDate }}
            </div>
            <div class="form-group" v-show="group == editedGroup"
                 v-on:blur="group.editedGroup=false; $emit('update')">
              <datepicker
                @keyup.enter="updateGroup(group)" v-model.lazy="group.end">
              </datepicker>
            </div>
          </td>
          <td v-if="showGroupLink()">
            <div v-show="group === editedGroup" @click="updateGroup(group)">
              <button type="primary" class="btn btn-outline-primary  my-2 my-sm-0">
                <font-awesome-icon icon="check"/>
              </button>
            </div>
          </td>

        </tr>
        </tbody>
      </table>
    </div>
  </div>
  </div>
</template>

<script>
export default {}
</script>

<style lang="css">
</style>
