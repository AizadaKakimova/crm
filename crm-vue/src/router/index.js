import Vue from 'vue'
import store from '../store.js'
import Router from 'vue-router'
import Signin from '@/components/pages/Signin'
import Signup from '@/components/pages/Signup'
import ForgotPassword from '@/components/pages/ForgotPassword'
import ResetPassword from '@/components/pages/ResetPassword'
import UsersList from '@/components/admin/users/List'
import UserEdit from '@/components/admin/users/Edit'
import RequestsList from '@/components/admin/requests/List'
import RequestsShow from '@/components/admin/requests/Show'
import Home from '@/components/pages/Home'
import AdminDash from '@/components/admin/dashboard/Dashboard'
import UserCreate from '@/components/admin/users/New'
import UserProfile from '@/components/admin/users/Profile'
import CourseList from '@/components/admin/courses/List'
import GroupList from '@/components/admin/groups/List'
import GroupNew from '@/components/admin/groups/New'
import GroupShow from '@/components/admin/groups/Show'
import GroupEdit from '@/components/admin/groups/Edit'
import GroupSchedule from '@/components/admin/groups/Schedule'
import Analytics from '@/components/admin/analytics/Analytics'
import EnrollmentNew from '@/components/admin/enrollments/New'
import EnrollmentShow from '@/components/admin/enrollments/Show'
import InstructorsList from '@/components/admin/instructors/List'
import InstructorsShow from '@/components/admin/instructors/Show'
// import Program from '@/components/admin/courses/Program'
import CourseShow from '@/components/admin/courses/Show'
import CourseEdit from '@/components/admin/courses/Edit'
import CourseNew from '@/components/admin/courses/New'
import SalaryNew from '@/components/admin/salaries/New'
import SalaryEdit from '@/components/admin/salaries/Edit'
import SalaryList from '@/components/admin/salaries/List'
import InstructorDash from '@/components/instructor/dashboard/Dashboard'
import InstructorGroupShow from '@/components/instructor/groups/Show'
import InstructorGroupsList from '@/components/instructor/groups/GroupsList'
import InstructorLectures from '@/components/instructor/groups/Lectures'
import TeachingHours from '@/components/instructor/teaching_hours/Teaching'
import TimelineShow from '@/components/admin/timeline/Show'
import PaymentList from '@/components/admin/payments/List'
import CostsList from '@/components/admin/costs/List'
import CostEdit from '@/components/admin/costs/Edit'
import AttendanceShow from '@/components/instructor/groups/Attendance'
import TodosList from '@/components/admin/todos/List'
import CityList from '@/components/admin/city/List'
import CityNew from '@/components/admin/city/New'
import CityShow from '@/components/admin/city/Show'
import Admin from '@/components/admin/city/Admin'
import ManagerDash from '@/components/manager/dashboard/Dashboard'
import UsersListManager from '@/components/manager/users/List'
import UserEditManager from '@/components/manager/users/Edit'
import RequestsListManager from '@/components/manager/requests/List'
import RequestsShowManager from '@/components/manager/requests/Show'
import UserCreateManager from '@/components/manager/users/New'
import UserProfileManager from '@/components/manager/users/Profile'
import CourseListManager from '@/components/manager/courses/List'
import GroupListManager from '@/components/manager/groups/List'
import GroupNewManager from '@/components/manager/groups/New'
import GroupShowManager from '@/components/manager/groups/Show'
import GroupEditManager from '@/components/manager/groups/Edit'
import EnrollmentNewManager from '@/components/manager/enrollments/New'
import EnrollmentShowManager from '@/components/manager/enrollments/Show'
import InstructorsListManager from '@/components/manager/instructors/List'
import InstructorsShowManager from '@/components/manager/instructors/Show'
import CourseShowManager from '@/components/manager/courses/Show'
import CourseEditManager from '@/components/manager/courses/Edit'
import CourseNewManager from '@/components/manager/courses/New'
import SalaryNewManager from '@/components/manager/salaries/New'
import SalaryEditManager from '@/components/manager/salaries/Edit'
import SalaryListManager from '@/components/manager/salaries/List'
import ManagerTodosList from '@/components/manager/todos/List'
import StudentDashboard from '@/components/student/dashboard/Dashboard'
import StudentGroup from '@/components/student/groups/List'
import StudentGroupShow from '@/components/student/groups/Show'
import StudentSchedule from '@/components/student/Schedule'
import CourseStudent from '@/components/student/Courses/List'
import StudentInstructor from '@/components/student/groups/Instructor'
import PaymentChartList from '@/components/admin/payments/Chart'
import SubscriptionList from '@/components/admin/subscriptions/List'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/signin',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },


    // {
    //   path: '/astana',
    //   name: 'Home',
    //   component: Home
    // },
    // {
    //   path: '/almaty',
    //   name: 'Home',
    //   component: Home
    // },


    {
      path: '/forgot_password',
      name: 'ForgotPassword',
      component: ForgotPassword
    },
    {
      path: '/password_resets/:token',
      name: 'ResetPassword',
      component: ResetPassword
    },
    {
      path: '/admin/users',
      name: 'UsersList',
      component: UsersList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Пользователи'}
        ],
        requiresAuth: true
      }
    },
    {
      path: '/admin/users/:id',
      name: 'UserEdit',
      component: UserEdit,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Пользователи', link: '/admin/users'},
          {name: 'Изменить'}
        ]
      }
    },
    {
      path: '/admin/user/new',
      name: 'UserCreate',
      component: UserCreate,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Пользователи', link: '/admin/users'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/requests',
      name: 'RequestsList',
      component: RequestsList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Заявки'}
        ]
      }
    },
    {
      path: '/admin/requests/:id',
      name: 'RequestsShow',
      component: RequestsShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Заявки', link: '/admin/requests'},
          {name: 'Изменить'}
        ]
      }
    },
    // {
    //   path: '/admin/program',
    //   name: 'Program',
    //   component: Program,
    //   meta: {
    //     breadcrumb: [
    //       {name: 'Админ', link: '/admin/dashboard'},
    //       {name: 'Программа'}
    //     ]
    //   }
    // },
    // {
    //   path: '/:cityName',
    //   name: 'Home',
    //   component: Home
    // },
    {
      path: '/admin/dashboard',
      name: 'AdminDash',
      component: AdminDash,
      meta: {
        breadcrumb: [
          {name: 'Админ'}
        ],
        // requiresAuth: true
      }
    },
    {
      path: '/admin/analytics',
      name: 'Analytics',
      component: Analytics
    },
    {
      path: '/admin/course',
      name: 'CourseList',
      component: CourseList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Курсы'}
        ]
      }
    },
    {
      path: '/admin/course/new',
      name: 'CourseNew',
      component: CourseNew,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Курсы', link: '/admin/course'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/course/:id',
      name: 'CourseShow',
      component: CourseShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Курсы', link: '/admin/course'},
          {name: 'Информация'}
        ]
      }
    },
    {
      path: '/admin/course/:id/edit',
      name: 'CourseEdit',
      component: CourseEdit,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Курсы', link: '/admin/course'},
          {name: 'Изменить'}
        ]
      }
    },
    {
      path: '/admin/costs',
      name: 'CostsList',
      component: CostsList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Расходы'}
        ]
      }
    },
    {
      path: '/admin/costs/:id',
      name: 'CostEdit',
      component: CostEdit
    },
    {
      path: '/admin/timeline',
      name: 'TimelineShow',
      component: TimelineShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Timeline'}
        ]
      }
    },
    {
      path: '/admin/payments/chart',
      name: 'PaymentChartList',
      component: PaymentChartList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Оплаты', link: '/admin/payments'},
          {name: 'График оплат'}
        ]
      }
    },
    {
      path: '/admin/payments',
      name: 'PaymentList',
      component: PaymentList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/payments'},
          {name: 'Оплаты'}
        ]
      }
    },
    {
      path: '/admin/groups',
      name: 'GroupList',
      component: GroupList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Группы'}
        ]
      }
    },
    {
      path: '/admin/groups/new',
      name: 'GroupNew',
      component: GroupNew,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Группы', link: '/admin/groups'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/groups/:slug',
      name: 'GroupShow',
      component: GroupShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Группы', link: '/admin/groups'},
          {name: 'Информация'}
        ]
      }
    },
    {
      path: '/admin/schedule',
      name: 'GroupSchedule',
      component: GroupSchedule,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Расписание'}
        ]
      }
    },
    {
      path: '/admin/groups/:slug/edit',
      name: 'GroupEdit',
      component: GroupEdit
    },
    {
      path: '/admin/groups/:slug/enrollments/new',
      name: 'EnrollmentNew',
      component: EnrollmentNew,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Группы', link: '/admin/groups/'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/groups/:slug/enrollments/:id',
      name: 'EnrollmentShow',
      component: EnrollmentShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Группы', link: '/admin/groups/'},
          {name: 'Группа', link: '/admin/groups/:slug/'},
          {name: 'Зачисления', link: '/admin/groups/:slug/enrollments'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/enrollments/:id',
      name: 'EnrollmentShow',
      component: EnrollmentShow
    },
    {
      path: '/admin/users/profile/:id',
      name: 'UserProfile',
      component: UserProfile,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Пользователи', link: '/admin/users'},
          {name: 'Профиль'}
        ]
      }
    },
    {
      path: '/admin/instructors/',
      name: 'InstructorsList',
      component: InstructorsList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Преподаватели'}
        ]
      }
    },
    {
      path: '/admin/instructors/:id',
      name: 'InstructorsShow',
      component: InstructorsShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/'},
          {name: 'Преподаватели', link: '/admin/instructors'},
          {name: 'Информация'}
        ]
      }
    },
    {
      path: '/admin/instructors/salaries/:id',
      name: 'SalaryNew',
      component: SalaryNew
    },
    {
      path: '/admin/instructors/:id/salaries/:id',
      name: 'SalaryEdit',
      component: SalaryEdit
    },
    {
      path: '/admin/salaries',
      name: 'SalaryList',
      component: SalaryList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/'},
          {name: 'Преподаватели', link: '/admin/instructors'},
          {name: 'Зарплаты'}
        ]
      }
    },
    {
      path: '/admin/subscriptions',
      name: 'SubscriptionList',
      component: SubscriptionList,
      meta: {
        breadcrumb: [
          {name: 'Admin', link: '/admin/dashboard'},
          {name: 'Subscriptions'}
        ]
      }
    },
    {
      path: '/admin/todos',
      name: 'TodosList',
      component: TodosList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Todos'}
        ]
      }
    },
    {
      path: '/admin/cities',
      name: 'CityList',
      component: CityList,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Филиалы'}
        ]
      }
    },
    {
      path: '/admin/cities/new',
      name: 'CityNew',
      component: CityNew,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Филиалы', link: '/admin/cities'},
          {name: 'Добавить'}
        ]
      }
    },
    {
      path: '/admin/cities/admin/new',
      name: 'AdminNew',
      component: Admin,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Филиалы', link: '/admin/cities'},
          {name: 'Добавить админа'}
        ]
      }
    },
    {
      path: '/admin/cities/:id',
      name: 'CityShow',
      component: CityShow,
      meta: {
        breadcrumb: [
          {name: 'Админ', link: '/admin/dashboard'},
          {name: 'Филиалы', link: '/admin/cities'},
          {name: 'Филиал'}
        ]
      }
    },
    // routes for Instructor
    {
      path: '/instructor/dashboard',
      name: 'InstructorDash',
      component: InstructorDash,
       meta: {
        breadcrumb: [
          {name: 'Преподаватель'}
        ]
      }
    },
    {
      path: '/instructor/:id/groups/',
      name: 'InstructorGroupsList',
      component: InstructorGroupsList,
       meta: {
        breadcrumb: [
          {name: 'Преподаватель', link: '/instructor/dashboard'},
          {name: 'Группы'}
        ]
      }
    },
    {
      path: '/instructor/groups/:id',
      name: 'InstructorGroupShow',
      component: InstructorGroupShow,
      meta: {
        breadcrumb: [
          {name: 'Преподаватель', link: '/instructor/dashboard'},
          {name: 'Группа'}
        ]
      }
    },
    {
      path: '/instructor/groups/:id/lectures',
      name: 'InstructorLectures',
      component: InstructorLectures,
      meta: {
        breadcrumb: [
          {name: 'Преподаватель', link: '/instructor/dashboard'},
          {name: 'Группа'}
        ]
      }
    },
    {
      path: '/instructor/hours/:id',
      name: 'TeachingHours',
      component: TeachingHours
    },
    {
      path: '/instructor/groups/attendance/:id',
      name: 'AttendanceShow',
      component: AttendanceShow,
      meta: {
        breadcrumb: [
          {name: 'Преподаватель', link: '/instructor/dashboard'},
          {name: 'Группа', link: '/instructor/groups/:id'},
          {name: 'Посещаемость'}
        ]
      }
    },
    // routes for Manager
    {
      path: '/manager/users',
      name: 'UsersList',
      component: UsersListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Users'}
        ]
      }
    },
    {
      path: '/manager/users/:id',
      name: 'UserEdit',
      component: UserEditManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Users', link: '/manager/users'},
          {name: 'Edit'}
        ]
      }
    },
    {
      path: '/manager/users/new',
      name: 'UserCreate',
      component: UserCreateManager
    },
    {
      path: '/manager/requests',
      name: 'RequestsList',
      component: RequestsListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Requests'}
        ]
      }
    },
    {
      path: '/manager/requests/:id',
      name: 'RequestsShow',
      component: RequestsShowManager
    },
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/manager/dashboard',
      name: 'ManagerDash',
      component: ManagerDash,
      meta: {
        breadcrumb: [
          {name: 'Manager'}
        ]
      }
    },
    {
      path: '/manager/courses',
      name: 'CourseList',
      component: CourseListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Courses'}
        ]
      }
    },
    {
      path: '/manager/courses/new',
      name: 'CourseNew',
      component: CourseNewManager
    },
    {
      path: '/manager/courses/:id',
      name: 'CourseShow',
      component: CourseShowManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Courses', link: '/manager/courses'},
          {name: 'Show'}
        ]
      }
    },
    {
      path: '/manager/courses/:id/edit',
      name: 'CourseEdit',
      component: CourseEditManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Courses', link: '/manager/courses'},
          {name: 'Edit'}
        ]
      }
    },
    {
      path: '/manager/groups',
      name: 'GroupList',
      component: GroupListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Groups'}
        ]
      }
    },
    {
      path: '/manager/groups/new',
      name: 'GroupNew',
      component: GroupNewManager
    },
    {
      path: '/manager/groups/:slug',
      name: 'GroupShowManager',
      component: GroupShowManager
    },
    {
      path: '/manager/groups/:slug/enrollments/new',
      name: 'EnrollmentNew',
      component: EnrollmentNewManager
    },
    {
      path: '/manager/groups/:slug/enrollments/:id',
      name: 'EnrollmentShow',
      component: EnrollmentShowManager
    },
    {
      path: '/manager/groups/:slug/edit',
      name: 'GroupEditManager',
      component: GroupEditManager
    },
    {
      path: '/manager/users/profile/:id',
      name: 'UserProfile',
      component: UserProfileManager
    },
    {
      path: '/manager/instructors/',
      name: 'InstructorsList',
      component: InstructorsListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/dashboard'},
          {name: 'Instructors'}
        ]
      }
    },
    {
      path: '/manager/instructors/:id',
      name: 'InstructorsShow',
      component: InstructorsShowManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager'},
          {name: 'Instructors', link: '/manager/instructors'},
          {name: 'Show'}
        ]
      }
    },
    {
      path: '/manager/instructors/salaries/:id',
      name: 'SalaryNew',
      component: SalaryNewManager
    },
    {
      path: '/manager/instructors/:id/salaries/:id',
      name: 'SalaryEdit',
      component: SalaryEditManager
    },
    {
      path: '/manager/todos',
      name: 'ManagerTodosList',
      component: ManagerTodosList
    },
    {
      path: '/manager/salaries',
      name: 'SalaryList',
      component: SalaryListManager,
      meta: {
        breadcrumb: [
          {name: 'Manager', link: '/manager/'},
          {name: 'Instructors', link: '/manager/instructors'},
          {name: 'Salaries'}
        ]
      }
    },
    {
      path: '/student/dashboard',
      name: 'StudentDashboard',
      component: StudentDashboard,
    },
    {
      path: '/student/groups',
      name: 'StudentGroup',
      component: StudentGroup
    },
    {
      path: '/student/groups/:slug',
      name: 'StudentGroupShow',
      component: StudentGroupShow
    },
    {
      path: '/student/instructor/:id',
      name: 'StudentInstructor',
      component: StudentInstructor
    },
    {
      path: '/student/schedule',
      name: 'StudentSchedule',
      component: StudentSchedule
    },
    {
      path: '/student/courses',
      name: 'CourseStudent',
      component: CourseStudent
    }
  ]
})

// Router.beforeEach((to, from, next) => {
//     if (to.matched.some(m => m.meta.requiresAuth)) {
//       alert('first')
//       if (store.state.signedIn) {
//           alert('f')
//         } else {
//           alert('t')
//         }
//       }
//     else{
//       alert('close')
//       next()
//     }
// });
//
//
// export default router;
