<template>
  <v-dialog max-width="600px"
            v-model="dialogVisible">
    <template v-slot:activator="{ props }">
      <v-btn flat
             v-bind="props"
             class="bg-success">
        Pedir Póliza
      </v-btn>
    </template>
    <v-card>
      <v-card-title>
        <h3>Pedir Nueva Póliza</h3>
      </v-card-title>
      <v-card-text>
        <v-form class="px-3"
                ref="form"
                @submit.prevent="validate">
          <!-- Campo para mostrar el nombre de usuario -->
          <v-text-field
            label="Usuario"
            v-model="username"
            :rules="[v => !!v || 'Campo requerido']"
            color="primary"
            variant="underlined"
            readonly
          >
            <template v-slot:prepend>
              <v-icon>mdi-account</v-icon>
            </template>
          </v-text-field>

          <v-select
            label="Agencia"
            v-model="agency"
            :items="agencias"
            item-title="nombre"
            item-value="nombre"
            :rules="[v => !!v || 'Campo requerido']"
            color="primary"
            variant="underlined"
          >
            <template v-slot:prepend>
              <v-icon>mdi-office-building</v-icon>
            </template>
          </v-select>

          <v-select
            label="Tipo de Seguro"
            v-model="insuranceType"
            :items="tiposSeguro"
            item-title="nombre"
            item-value="nombre"
            :rules="[v => !!v || 'Campo requerido']"
            color="primary"
            variant="underlined"
          >
            <template v-slot:prepend>
              <v-icon>mdi-shield-check</v-icon>
            </template>
          </v-select>

          <v-select
            label="Tipo de Cobertura"
            v-model="coverageType"
            :items="tiposCoberturas"
            item-title="nombre"
            item-value="nombre"
            :rules="[v => !!v || 'Campo requerido']"
            color="primary"
            variant="underlined"
          >
            <template v-slot:prepend>
              <v-icon>mdi-shield-outline</v-icon>
            </template>
          </v-select>

          <v-row class="mt-4"
                 justify="start">
            <v-col align-self="start"
                   cols="9">
              <v-btn flat
                     class="bg-success mr-16"
                     @click="validate">Enviar Solicitud
              </v-btn>
              <v-btn flat
                     color="red"
                     @click="closeDialog">Salir
              </v-btn> <!-- Botón para salir -->
            </v-col>
          </v-row>

        </v-form>
      </v-card-text>
    </v-card>

    <!-- Mostrar la lista de pólizas si el usuario es un trabajador -->
    <div v-if="userType === 'Trabajador'">
      <h3>Lista de Solicitudes de Póliza</h3>
      <ul>
        <li v-for="(poliza, index) in polizas"
            :key="index">
          {{
            poliza.username
          }} - {{
            poliza.agency
          }} - {{
            poliza.insuranceType
          }} - {{
            poliza.coverageType
          }}
        </li>
      </ul>
    </div>

  </v-dialog>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      dialogVisible: false,
      username: '', // Almacenará el nombre del usuario
      agency: null,
      agencias: [], // Inicializar como vacío
      insuranceType: null,
      coverageType: null,
      tiposSeguro: [], // Inicializar como vacío
      tiposCoberturas: [], // Inicializar como vacío
      polizas: [], // Almacena la lista de pólizas
    };
  },
  created() {
    this.loadUsername(); // Cargar el nombre del usuario al crear el componente
    this.fetchData(); // Cargar datos necesarios para el formulario al crear el componente
    this.fetchPolizas(); // Cargar las pólizas almacenadas al crear el componente
  },
  methods: {
    loadUsername() {
      const storedUser = sessionStorage.getItem('userName'); // Obtener el nombre del usuario del session storage
      if (storedUser) {
        this.username = storedUser; // Establecer el nombre como valor inicial
      }
    },

    async fetchData() {
      try {
        const [polizasRes, agenciasRes, tiposSeguroRes, tiposCoberturaRes] = await Promise.all([
          axios.get('/getAllPolizas'),
          axios.get('/getAllAgencias'),
          axios.get('/getAllTipoSeguros'),
          axios.get('/getAllCoberturas'),
        ]);

        this.polizas = polizasRes.data; // Almacenar las pólizas si es necesario
        this.agencias = agenciasRes.data.map(agencia => ({
          id: agencia.id_agencia_seguro,
          nombre: agencia.nombre_agencia_seguro,
        }));
        this.tiposSeguro = tiposSeguroRes.data.map(tipo => ({
          id: tipo.id_tipo_seguro,
          nombre: tipo.nombre_tipo_seguro,
        }));
        this.tiposCoberturas = tiposCoberturaRes.data.map(cobertura => ({
          id: cobertura.id_tipo_cobertura,
          nombre: cobertura.nombre_tipo_cobertura,
        }));

      } catch (error) {
        console.error('Error al cargar los datos:', error);
      }
    },

    async validate() {
      const {valid} = await this.$refs.form.validate();
      if (valid) {
        alert('Solicitud enviada con éxito');

        // Crear objeto con los datos del formulario
        const newPoliza = {
          username: this.username,
          agency: this.agency,
          insuranceType: this.insuranceType,
          coverageType: this.coverageType,
        };

        // Guardar la nueva póliza en local storage
        this.savePoliza(newPoliza);

        this.closeDialog(); // Cerrar el diálogo después de enviar
      }
    },

    savePoliza(poliza) {
      let existingPolizas = JSON.parse(localStorage.getItem('polizaList')) || [];

      existingPolizas.push(poliza);

      localStorage.setItem('polizaList', JSON.stringify(existingPolizas));

      this.polizas = existingPolizas;
    },

    fetchPolizas() {
      const storedData = localStorage.getItem('polizaList');
      if (storedData) {
        this.polizas = JSON.parse(storedData);
      }
    },

    closeDialog() {
      this.dialogVisible = false; // Cerrar el diálogo
    },
  },
};
</script>

<style scoped>
/* Estilos adicionales si es necesario */
</style>
