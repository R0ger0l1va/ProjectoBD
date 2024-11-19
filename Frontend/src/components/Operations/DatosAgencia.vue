<template>
  <div class="gestion-elementos">
    <h2>Gestión de Elementos</h2>
    <div class="operation-selector">
      <button @click="selectedOperation = 'insertar'" :class="{ active: selectedOperation === 'insertar' }">Insertar</button>
      <button @click="selectedOperation = 'modificar'" :class="{ active: selectedOperation === 'modificar' }">Modificar</button>
      <button @click="selectedOperation = 'eliminar'" :class="{ active: selectedOperation === 'eliminar' }">Eliminar</button>
    </div>
    <div class="element-selector">
      <label for="elemento">Elemento:</label>
      <select v-model="selectedElement" id="elemento" @change="resetForm">
        <option value="pais">País</option>
        <option value="agencia">Agencia</option>
        <option value="reclamacion">Reclamación</option>
        <option value="reaseguradora">Compañía Reaseguradora</option>
      </select>
    </div>
    <div class="formulario">
      <form @submit.prevent="submitForm">
        <div v-if="selectedOperation === 'modificar' || selectedOperation === 'eliminar'" class="campo">
          <label :for="`id_${selectedElement}`">ID {{ getElementName }}:</label>
          <select :id="`id_${selectedElement}`" v-model="formData[`id_${selectedElement}`]" required>
            <option v-for="id in getIds()" :key="id.id" :value="id.id">{{ id.nombre }}</option>
          </select>
        </div>
        <template v-if="selectedOperation !== 'eliminar'">
          <div v-if="selectedElement === 'pais'" class="campo">
            <label for="nombre_pais">Nombre País:</label>
            <input id="nombre_pais" v-model="formData.nombre_pais" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="nombre_agencia_seguro">Nombre Agencia:</label>
            <input id="nombre_agencia_seguro" v-model="formData.nombre_agencia_seguro" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="direccion_postal">Dirección Postal:</label>
            <input id="direccion_postal" v-model="formData.direccion_postal" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="telefono">Teléfono:</label>
            <input id="telefono" v-model="formData.telefono" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="correo_electronico">Correo Electrónico:</label>
            <input id="correo_electronico" v-model="formData.correo_electronico" type="email" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="nombre_director_general">Nombre Director General:</label>
            <input id="nombre_director_general" v-model="formData.nombre_director_general" required>
          </div>
          <div v-if="selectedElement === 'agencia'" class="campo">
            <label for="nombre_jefe_departamento_seguros">Nombre Jefe Departamento Seguros:</label>
            <input id="nombre_jefe_departamento_seguros" v-model="formData.nombre_jefe_departamento_seguros" required>
          </div>
          <div v-if="selectedElement === 'reclamacion'" class="campo">
            <label for="numero_poliza">Número Póliza:</label>
            <select id="numero_poliza" v-model="formData.numero_poliza" required>
              <option v-for="poliza in polizas" :key="poliza.numero_poliza" :value="poliza.numero_poliza">
                {{ poliza.numero_poliza }}
              </option>
            </select>
          </div>
          <div v-if="selectedElement === 'reclamacion'" class="campo">
            <label for="id_estado_reclamacion">Estado Reclamación:</label>
            <select id="id_estado_reclamacion" v-model="formData.id_estado_reclamacion" required>
              <option value="1">Pendiente</option>
              <option value="2">En proceso</option>
              <option value="3">Resuelta</option>
            </select>
          </div>
          <div v-if="selectedElement === 'reclamacion'" class="campo">
            <label for="id_tipo_siniestro">Tipo Siniestro:</label>
            <select id="id_tipo_siniestro" v-model="formData.id_tipo_siniestro" required>
              <option value="1">Accidente</option>
              <option value="2">Robo</option>
              <option value="3">Incendio</option>
            </select>
          </div>
          <div v-if="selectedElement === 'reclamacion'" class="campo">
            <label for="fecha_siniestro">Fecha Siniestro:</label>
            <input id="fecha_siniestro" v-model="formData.fecha_siniestro" type="date" required>
          </div>
          <div v-if="selectedElement === 'reclamacion'" class="campo">
            <label for="monto_reclamado">Monto Reclamado:</label>
            <input id="monto_reclamado" v-model="formData.monto_reclamado" type="number" step="0.01" required>
          </div>
          <div v-if="selectedElement === 'reaseguradora'" class="campo">
            <label for="id_pais">País:</label>
            <select id="id_pais" v-model="formData.id_pais" required>
              <option v-for="pais in paises" :key="pais.id" :value="pais.id">{{ pais.nombre }}</option>
            </select>
          </div>
          <div v-if="selectedElement === 'reaseguradora'" class="campo">
            <label for="id_tipo_reaseguro">Tipo Reaseguro:</label>
            <select id="id_tipo_reaseguro" v-model="formData.id_tipo_reaseguro" required>
              <option value="1">Proporcional</option>
              <option value="2">No proporcional</option>
            </select>
          </div>
          <div v-if="selectedElement === 'reaseguradora'" class="campo">
            <label for="nombre_compannia_reaseguradora">Nombre Compañía Reaseguradora:</label>
            <input id="nombre_compannia_reaseguradora" v-model="formData.nombre_compannia_reaseguradora" required>
          </div>
        </template>
        <button type="submit" class="boton-submit">{{ getButtonText }}</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'GestionElementos',
  data() {
    return {
      selectedOperation: 'insertar',
      selectedElement: 'pais',
      formData: {},
      paises: [],
      polizas: [],
      elementIds: {
        pais: [],
        agencia: [],
        reclamacion: [],
        reaseguradora: []
      }
    }
  },
  computed: {
    getElementName() {
      const names = {
        pais: 'Pais',
        agencia: 'Agencia',
        reclamacion: 'Reclamación',
        reaseguradora: 'Compañía Reaseguradora'
      }
      return names[this.selectedElement]
    },
    getButtonText() {
      const texts = {
        insertar: 'Insertar',
        modificar: 'Modificar',
        eliminar: 'Eliminar'
      }
      return texts[this.selectedOperation]
    }
  },
  methods: {
    resetForm() {
      this.formData = {}
    },
    getIds() {
      return this.elementIds[this.selectedElement]
    },
    async fetchData() {
      try {
        const [paisesRes, agenciasRes, reclamacionesRes, reaseguradorasRes, polizasRes] = await Promise.all([
          axios.get('/getPais'),
          axios.get('/getAllAgencias'),
          axios.get('/getReclamacion'),
          axios.get('/getReaseguradora'),
          axios.get('/getAllPolizas')
        ])
        this.paises = paisesRes.data.map(pais => ({ id: pais.id_pais, nombre: pais.nombre_pais }))
        this.elementIds.pais = paisesRes.data.map(pais => ({ id: pais.id_pais, nombre: pais.nombre_pais }))
        this.elementIds.agencia = agenciasRes.data.map(agencia => ({id: agencia.id_agencia_seguro, nombre: agencia.nombre_agencia_seguro}))
        this.elementIds.reclamacion = reclamacionesRes.data.map(reclamacion => ({id: reclamacion.numero_reclamacion, nombre: reclamacion.numero_reclamacion}))
        this.elementIds.reaseguradora = reaseguradorasRes.data.map(reaseguradora => ({id: reaseguradora.id_comp_reaseguradora, nombre: reaseguradora.id_comp_reaseguradora}))
        this.polizas = polizasRes.data
      } catch (error) {
        console.error('Error fetching data:', error)
      }
    },
    async submitForm() {
      try {
        let response;
        const id = this.formData[`id_${this.selectedElement}`];
        const endpoint = {
          pais: 'Pais',
          agencia: 'Agencia',
          reclamacion: 'Reclamacion',
          reaseguradora: 'Reaseguradora'
        }[this.selectedElement];

        switch (this.selectedOperation) {
          case 'insertar':
            response = await axios.post(`/insert${endpoint}`, this.formData);
            break;
          case 'modificar':
            response = await axios.put(`/upd${endpoint}/${id}`, this.formData);
            break;
          case 'eliminar':
            response = await axios.delete(`/del${endpoint}/${id}`);
            break;
        }

        console.log('Respuesta del servidor:', response.data);
        alert(`${this.getElementName} ${this.getButtonText.toLowerCase()}do con éxito`);
        this.resetForm();
        this.fetchData();
      } catch (error) {
        console.error('Error al realizar la operación:', error);
        alert(`Error al ${this.getButtonText.toLowerCase()} ${this.getElementName.toLowerCase()}`);
      }
    }
  },
  mounted() {
    this.fetchData()
  }
}
</script>

<style scoped>
.gestion-elementos {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.operation-selector {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.operation-selector button {
  flex: 1;
  padding: 10px;
  background-color: #f0f0f0;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.operation-selector button.active {
  background-color: #4caf50;
  color: white;
}

.element-selector {
  margin-bottom: 20px;
}

.formulario {
  background-color: #f5f5f5;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.campo {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
  color: #333;
}

input,
select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 14px;
}

.boton-submit {
  width: 100%;
  padding: 10px;
  background-color: #4caf50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.boton-submit:hover {
  background-color: #45a049;
}

@media (max-width: 600px) {
  .gestion-elementos {
    max-width: 100%;
    padding: 10px;
  }
}
</style>