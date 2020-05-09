<template>
  <div class="sidebar">
    <ul id="navigation" class="list-group list-group-flush">
      
      <li>
        <router-link :to="`/admin/dashboard`" class="list-group-item list-group-item-action">
            Админ
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/users`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="users" style="width: 1.8rem" /> Пользователи
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/requests`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="user-plus" style="width: 1.8rem"/> Заявки
        </router-link>
        </li>
      <li>
        <router-link :to="`/admin/timeline`" class="list-group-item list-group-item-action">
         <font-awesome-icon icon="calendar-alt"  style="width: 2rem"/>Таймлайн
        </router-link>
      </li>
      <li><router-link :to="`/admin/schedule`" class="list-group-item list-group-item-action">
        <font-awesome-icon icon="calendar-week"  style="width: 2rem"/>Расписание
      </router-link>
      </li>
      <li>
        <router-link :to="`/admin/groups`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="university" style="width: 2rem"/>Группы
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/payments`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="money-bill-alt" style="width: 2rem"/>Оплаты
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/todos`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="list-ul" style="width: 2rem"/>Тодо
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/costs`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="minus-square" style="width: 2rem"/>Расходы
        </router-link>
      </li>
      <li>
        <router-link :to="`/admin/course`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="book" style="width: 2rem"/>Курсы
        </router-link>
      </li>
      <li :if="`${this.$store.getters.isSuperUser}`">
        <router-link :to="`/admin/cities`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="book" style="width: 2rem"/>Филиалы
        </router-link>
      </li>
      <!-- <li>
        <router-link :to="`/admin/program`" class="list-group-item list-group-item-action">
          <font-awesome-icon icon="book" style="width: 2rem"/>Программа курсов
        </router-link>
      </li> -->
    </ul>
  </div>
</template>
<script>
export default {
  name: 'AdminSidebar'
}
</script>
<style lang="css" scoped>
.sidebar {
  padding-top: 10%;
  background-color: #fff;
  margin-top: 20%;
  box-shadow: 1px 1px rgba(0,0,0,.125);
}
 #navigation li {
  color: #6c757d;
  background-color: #fff;
  border: white;
  font-size: 0.8rem;
  line-height: 2rem;
}
#white{
  color: white;
}
.active {
  color:black !important;
  text-decoration: none;
  background-color: white !important;
  font-weight: bold;
}
#white:hover {
  color:black;
  text-decoration: none;
}
.sidebar a:hover {
  text-decoration: none;
}
.sidebar ul {
   list-style-type:none;
   margin: 0;
   padding: 0

}
.sidemargin{
  padding-right: 7px;
}
.sidebar ul li{
  padding-left: 10;
}
#navigation li:hover{
   background-color: white;
   text: black;
}
</style>
