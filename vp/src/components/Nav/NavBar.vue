<template>
  <nav>
    <v-app-bar class="bg-grey-lighten-3"
               flat
               prominent>
      <v-app-bar-nav-icon
        color="black"
        v-show="state"
        @click="drawer = !drawer"
      ></v-app-bar-nav-icon>
      <v-toolbar-title class="text-uppercase text-grey">
        <span class="font-weight-light text-light-blue-lighten-3">Heaven</span>
        <span class="text-light-blue"> Polizes</span>
      </v-toolbar-title>
      <v-spacer/>

      <v-menu v-if="state"
              location="bottom">
        <template v-slot:activator="{ props }">
          <span class="mx-5 mr-5"
                style="cursor: pointer"
                v-bind="props">
            <v-chip link>
              <v-badge color="green"
                       dot
                       offset-x="3"
                       offset-y="15">
                <v-avatar size="25">
                  <v-img src="/logo.png"></v-img>
                </v-avatar>
              </v-badge>
              <span class="ml-2">{{
                  userName
                }}</span>
            </v-chip>
          </span>
        </template>
        <v-list class="py-0 mt-2">
          <v-list-item>
            <template v-slot:prepend>
              <v-avatar size="30">
                <v-img src="/logo.png"></v-img>
              </v-avatar>
            </template>
            <v-list-item-title>{{
                userName
              }}

            </v-list-item-title>
            <v-list-item-subtitle>Logged In</v-list-item-subtitle>
          </v-list-item>
          <v-divider/>


          <v-list nav>
            <v-list-item
              v-for="item in filteredMenuItems"
              :key="item.text"
              @click="item.action"
              color="black"
              rounded="xl"
            >
              <template v-slot:prepend>
                <v-icon class="text-black">{{
                    item.icon
                  }}
                </v-icon>
              </template>
              <v-list-item-title
                class="text-black"
                v-text="item.text"
              ></v-list-item-title>
            </v-list-item>




          </v-list>
        </v-list>
      </v-menu>



    </v-app-bar>
    <v-navigation-drawer
      v-model="drawer"
      :location="$vuetify.display.mobile ? 'bottom' : undefined"
      class="bg-primary"
      v-if="state"
    >
      <v-row class="mt-8 mb-3"
             justify="center">
        <v-col cols="5">
          <v-avatar class="bg-grey-lighten-3"
                    size="80"></v-avatar>
          <p class="text-white text-h6 mt-3 ml-3">{{
              userName
            }}</p>
        </v-col>
      </v-row>
      <v-row class="mt-3 mb-4"
             justify="center"
             v-if="userType === 'Cliente'">
        <req-poliza/>
      </v-row>
      <v-row class="mt-3 mb-4"
             justify="center"></v-row>
      <v-list density="default"
              nav>
        <v-list-item
          v-for="link in links"
          :key="link.text"
          :to="link.route"
          :active="isRouteActive(link.route)"
          color="white"
          rounded="xl"
          router
        >
          <template v-slot:prepend>
            <v-icon class="text-white">{{
                link.icon
              }}
            </v-icon>
          </template>
          <v-list-item-title
            class="text-white"
            v-text="link.text"
          ></v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <!-- Profile Dialog -->
    <v-dialog v-model="showProfileDialog"
              max-width="500px">
      <v-card>
        <v-card-title>
          <span class="text-h5">User Profile</span>
        </v-card-title>
        <v-card-text>
          <v-list>
            <v-list-item>
              <v-list-item-title>Name:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.nombre_cliente
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Last Name:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.apellido_cliente
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Email:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.correo_electronico
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Phone:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.telefono
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Age:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.edad
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>ID:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.carnet_identidad
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Postal Adress:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.direccion_postal
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Country:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.id_pais
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <v-list-item>
              <v-list-item-title>Sex:</v-list-item-title>
              <v-list-item-subtitle>{{
                  clientData.id_sexo
                }}
              </v-list-item-subtitle>
            </v-list-item>
            <!-- Add more user details here -->
          </v-list>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue darken-1"
                 text
                 @click="showProfileDialog = false"
          >Close
          </v-btn
          >
        </v-card-actions>
      </v-card>
    </v-dialog>
  </nav>
</template>

<script>
import reqPoliza from "@/components/Operations/ReqPoliza.vue";

export default {
  components: {reqPoliza},
  props: {
    state: {
      type: Boolean,
      required: true,
    },
    clientData: {
      type: Object,
      default: () => ({}),
    },
    userType: {
      type: String,
      required: true,
    },
    userName: {
      type: String,
      default: "User",
    },
  },
  data() {
    return {
      drawer: false,
      links: [],
      userMenuItems: [
        {
          icon: "mdi-account",
          text: "Profile",
          action: () => (this.showProfileDialog = true),
        },
        
        {icon: "mdi-logout", text: "Logout", action: this.logout},
      ],
      showProfileDialog: false,
      showChangePasswordDialog: false,
      currentPassword: "",
      newPassword: "",
      confirmPassword: "",
    };
  },
  created() {
    this.updateLinks();
  },
  computed: {
    filteredMenuItems() {
      if (this.userType === "Cliente") {
        return this.userMenuItems;
        //Solo devuelve el primer elemento
      }
      return this.userMenuItems.slice(1)      // Devuelve todos los elementos si no es 'Cliente'
    },
  },
  watch: {
    userType: {
      handler: "updateLinks",
      immediate: true,
    },
  },
  methods: {



    updateLinks() {
      switch (this.userType) {
        case "Trabajador":
          this.links = [

            {
              icon: "mdi-card-account-details",
              text: "Polizes",
              route: "/polilist",
            },
            {
              icon: "mdi-account-group",
              text: "Users",
              route: "/userList",
            },
            {
              icon: "mdi-file-pdf-box",
              text: "Documents",
              route: "/documentList",
            },
            {
              icon: "mdi-view-list",
              text: "Pedidos",
              route: "/pedidos",
            }
          ];
          break;
        case "AdminGen":
          this.links = [

            {
              icon: "mdi-card-account-details",
              text: "Polizes",
              route: "/polilist",
            },
            {
              icon: "mdi-account-group",
              text: "Users",
              route: "/userList",
            },
            {
              icon: "mdi-file-pdf-box",
              text: "Documents",
              route: "/documentList",
            },
            {
              icon: "mdi-view-list",
              text: "Pedidos",
              route: "/pedidos",
            }
          ];
          break;
        case "Cliente":
          this.links = [
            {
              icon: "mdi-view-dashboard",
              text: "Dashboard",
              route: "/clientview",
            },
            {
              icon: "mdi-card-account-details",
              text: "My Polizes",
              route: "/policard",
            },


          ];
          break;
        default:
          this.links = [];
      }
    },
    isRouteActive(route) {
      return this.$route.path.startsWith(route);
    },
    logout() {
      // Implement logout logic here
      console.log("Logging out...");
      // For example:
      // this.$store.dispatch('logout')
      // this.$router.push('/login')
      this.$router.push('/')
      sessionStorage.removeItem('token')

    },
    changePassword() {
      // Implement password change logic here
      console.log("Changing password...");
      // For example:
      // if (this.newPassword === this.confirmPassword) {
      //   // Call API to change password
      //   // this.$store.dispatch('changePassword', {
      //   //   currentPassword: this.currentPassword,
      //   //   newPassword: this.newPassword
      //   // })
      // } else {
      //   // Show error message
      // }
      this.showChangePasswordDialog = false;
      this.currentPassword = "";
      this.newPassword = "";
      this.confirmPassword = "";
    },
  },
};
</script>

<style scoped>
/* Add any scoped styles here if needed */
</style>
