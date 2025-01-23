<template>
  <h1>La lista de Usuarios</h1>

  <v-data-table-server
    :group-by="groupBy"
    :headers="headers"
    :items="userIDS"
    :items-length="userIDS.length"
    :loading="loading"
    item-value="nombre"
    @update:options="fechDataUser">

    <template v-slot:group-header="{ item, columns, toggleGroup, isGroupOpen }">
      <tr>
        <td :colspan="columns.length">
          <VBtn
            :icon="isGroupOpen(item) ? '$expand' : '$next'"
            size="small"
            variant="text"
            @click="toggleGroup(item)"
          ></VBtn>
          <v-chip :color="getColor(item.value)">{{
              item.value === 'Cliente' ? 'Cliente' : 'Trabajador'
            }}
          </v-chip>

        </td>
      </tr>
    </template>

    <template v-slot:top>
      <v-toolbar flat>
        <v-toolbar-title>LISTA DE USUARIOS</v-toolbar-title>
        <v-divider class="mx-4"
                   inset
                   vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog"
                  max-width="500px"
        >
          <template v-slot:activator="{props}">
            <v-btn class="mb-1"
                   color="primary"
                   dark
                   v-bind="props"> Nuevo Usuario
            </v-btn>
          </template>
          <v-form ref="form">
            <v-card>
              <v-card-title><span class="text-h5">{{
                  formTitle
                }}</span></v-card-title>
              <v-card-text>
                <v-container>
                  <v-row justify="center">
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-text-field v-model="editedUser.nombre"
                                    variant="underlined"
                                    label="Nombre de Usuario"
                                    :rules="rules.nombreRule"

                      >
                      </v-text-field>
                    </v-col>
                    <v-col cols="12"
                           md="4"
                           sm="6">
                      <v-select v-model="editedUser.rol"
                                :items="roles"
                                variant="underlined"
                                :rules="rules.rol"
                                label="rol"
                      ></v-select>
                    </v-col>

                    <v-container v-if="editedUser.rol==='Cliente'"
                                 class="border-solid"
                                 border="primary xl"
                    >

                      <v-select
                        v-model="editedUser.id_pais"
                        variant="underlined"
                        :items="countries"
                        item-title="nombre"
                        :rules="rules.pais"
                        item-value="id"
                        label="pais"
                      ></v-select>
                      <v-select
                        v-model="editedUser.id_sexo"
                        :items="gender"
                        item-title="nombre"
                        :rules="rules.sexo"
                        item-value="id"
                        variant="underlined"
                        label="sexo"
                      ></v-select>
                      <v-text-field
                        v-model="editedUser.edad"
                        variant="underlined"
                        :rules="rules.edad"
                        placeholder="+18"
                        label="edad"
                      ></v-text-field>
                      <v-text-field
                        v-model="editedUser.correo_electronico"
                        variant="underlined"
                        :rules="rules.correo"
                        placeholder="example@gmail.com"
                        label="correo"
                      ></v-text-field>
                      <v-text-field
                        v-model="editedUser.telefono"
                        variant="underlined"
                        label="telefono"
                      ></v-text-field>
                    </v-container>


                  </v-row>
                </v-container>
              </v-card-text>
              <v-card-actions class="justify-center">
                <v-btn color="blue-darken-1"
                       variant="text"
                       @click="close"
                >Cancel
                </v-btn>
                <v-btn
                  color="blue-darken-1"
                  variant="text"
                  @click="save"
                >
                  Save
                </v-btn>
              </v-card-actions>
            </v-card>
          </v-form>
        </v-dialog>
        <v-dialog v-model="dialogDelete"
                  max-width="500px">
          <v-card>
            <v-card-title class="text-h5">Estas Seguro de Eliminar este Usuario?</v-card-title>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue-darken-1"
                     variant="text"
                     @click="closeDelete">Cancel
              </v-btn>
              <v-btn color="blue-darken-1"
                     variant="text"
                     @click="deleteItemConfirm"
              >OK
              </v-btn>
              <v-spacer></v-spacer>
            </v-card-actions>
          </v-card>
        </v-dialog>

      </v-toolbar>
    </template>
    <template v-slot:item.actions="{item}">
      <template v-if="item.rol==='Trabajador' && actualUser==='AdminGen'">
        <v-icon
          class="me-2"
          size="small"
          @click="editUser(item)"
        >
          mdi-pencil
        </v-icon>
      </template>

      <template v-if="(item.rol==='Cliente' && actualUser==='Trabajador')  || (item.rol==='Trabajador' && actualUser==='AdminGen')">
        <v-icon
          size="small"
          @click="deleteUser(item)"


        >
          mdi-delete
        </v-icon>
      </template>
    </template>
    <template v-slot:no-data>
      <v-btn
        color="primary"
        @click="fechDataUser"
      >
        Reset
      </v-btn>
    </template>


  </v-data-table-server>
</template>

<script>
import * as promise from "axios";
import axios from "axios";

export default {
  name: 'UserList',
  data() {
    return {
      countries: [],
      actualUser: '',
      gender: [],
      loading: false,
      editedIndex: -1,
      defaultUser: {},
      editedUser: {},
      dialog: false,
      dialogDelete: false,
      show: false,
      password: 'Password',
      userTarget: 0,


      groupBy: [{
        key: 'rol',
        order: 'asc',
      }],
      headers: [
        {title: 'Nombre Usuario', align: 'start', key: 'nombre', sortable: false},
        {title: 'Actions', key: 'actions', sortable: false}],
      userIDS: [],
      rules: {
        edad: [v => !!v || 'Campo requerido', v => v >= 18 || 'Debe ser mayor de 18 años', v => v <= 100 || 'Debe ser menor de 100 años'],
        pais: [v => !!v || 'Seleccione su país'],
        correo: [v => !!v || !this.editedUser.telefono || 'Campo requerido si no hay teléfono', v => !v || /.+@.+\..+/.test(v) || 'E-mail debe ser válido'],
        sexo: [v => !!v || 'Seleccione su sexo'],
        nombreRule: [v => !!v || 'Campo requerido', v => v.length >= 3 || 'Mínimo 3 caracteres', v => !/\d/.test(v) || 'No puede contener números'],
        rol: [v => !!v || 'Seleccione un rol'],

      }

    }
  },
  computed: {
    isCreating() {
      return this.editedIndex === -1;
    },
    formTitle() {
      return this.editedIndex === -1 ? 'New User' : 'Edit User'
    },
    roles() {
      if (this.actualUser === 'Trabajador') {
        return ['Cliente'];
      } else if (this.actualUser === 'AdminGen') {
        return ['Trabajador'];
      }
      return []; // Retorna un array vacío si no coincide con ninguno
    }
  },
  watch: {
    option: {
      handler() {
        this.fetchData();
      },
      deep: true, // Profundidad para observar cambios en objetos
    },
    dialog(val) {
      val || this.close()

    },
    dialogDelete(val) {
      val || this.closeDelete()
    },
  },
  methods: {
    async fechDataUser() {
      try {

        const [usuarios, sex, pais] = await Promise.all([
          axios.get('/getAllUsers'),
          axios.get('/getSex'),
          axios.get('/getPais'),
        ]);

        this.countries = pais.data.map((pais) => ({
          id: pais.id_pais,
          nombre: pais.nombre_pais
        }))
        this.gender = sex.data.map(sexo => ({
          id: sexo.id_sexo,
          nombre: sexo.nombre_sexo
        }));

        this.userIDS = usuarios.data.filter((usuario) => usuario.rol === 'Trabajador' || usuario.rol === 'Cliente').map((usuario) => ({
          id: usuario.id_usuario,
          nombre: usuario.nombre_usuario,
          rol: usuario.rol,


        }))

        if (this.userIDS.length > 0) {
          const keys = Object.keys(this.userIDS[0]);
          this.editedUser = Object.assign(Object.fromEntries(keys.map(key => [key, null])), {
            contrasenna: '0000'
          })

        }


      } catch (error) {
        console.error('Error fetching data:', error)
        alert('Error al cargar los datos. Por favor, intente de nuevo.')
      } finally {
        this.loading = false;
      }
    },

    close() {
      console.log(this.editedUser)
      this.dialog = false
      this.$nextTick(() => {
        this.editedUser = Object.assign({}, this.defaultUser)
        this.editedIndex = -1
      })
      this.fechDataUser()
    },

    getColor(rol) {
      let color = ''
      switch (rol) {
        case 'Cliente':
          color = 'green'
          break;
        case  'Trabajador':
          color = 'orange'
          break
      }
      return color
    },

    closeDelete() {
      this.dialogDelete = false
      this.$nextTick(() => {
        this.editedUser = Object.assign({}, this.defaultUser)
        this.editedIndex = -1
      })

    },

    async save() {
      if (!(await this.$refs.form.validate()).valid) {
        alert("HOLA")
        return
      }
      if (this.editedIndex > -1) {
        try {

          await axios.put(`/putUsers/${this.editedUser.id}`, this.editedUser)
          alert('Usuario modificada con éxito')

        } catch (error) {
          console.error('Error modificando el usuario:', error)
          alert('Error al modificar el usuario')
        }
      } else {

        try {
          console.log(this.editedUser)
          const res = await axios.post('/postTrabajador', this.editedUser)
          alert('Usuario creado con éxito')
          if (this.editedUser.rol === 'Cliente') {
            this.editedUser.id_numero_identidad_cliente = res.data.id_usuario
            console.log(this.editedUser)
            await axios.post('/postCliente', this.editedUser)
            alert('Cliente agregado')
          }
        } catch (error) {
          console.error('Error creating user:', error)
          alert('Error al crear usuario')
        }

      }
      this.close()
      this.fechDataUser()


    },

    editUser(item) {
      this.editedIndex = this.userIDS.indexOf(item)
      this.editedUser = Object.assign({}, item)
      console.log(this.editedUser)
      this.dialog = true
    },

    deleteUser(item) {
      this.editedIndex = this.userIDS.indexOf(item)
      this.editedUser = Object.assign({}, item)
      this.userTarget = this.editedUser.id
      this.dialogDelete = true
    },

    async deleteItemConfirm() {
      try {
        await axios.delete(`/delUsers/${this.userTarget}`)
        alert('Usuario eliminado con éxito')
        if (this.editedUser.rol === 'Cliente') {
          await axios.delete(`/delCliente/${this.userTarget}`)
          alert("Cliente eliminado con exito")
        }
      } catch (error) {
        console.error('Error eliminando el usuario:', error)
        alert('Error al eliminar el usuario')
      }

      this.closeDelete()
      this.fechDataUser()
    },


  },
  mounted() {
    this.fechDataUser()
    this.actualUser = sessionStorage.getItem('userType')
  }
}
</script>


