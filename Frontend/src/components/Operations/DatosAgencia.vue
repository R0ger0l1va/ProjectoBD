<template>
  <div class="form-container">
    <h2>Gestión de Elementos</h2>
    <div class="input-group">
      <label for="operacion">Operación:</label>
      <select v-model="selectedOperation" id="operacion" @change="resetForm">
        <option value="insertar">Insertar</option>
        <option value="modificar">Modificar</option>
        <option value="eliminar">Eliminar</option>
      </select>
    </div>
    <div class="input-group">
      <label for="elemento">Elemento:</label>
      <select v-model="selectedElement" id="elemento" @change="resetForm">
        <option value="pais">País</option>
        <option value="agencia">Agencia</option>
        <option value="reclamacion">Reclamación</option>
        <option value="reaseguradora">Compañía Reaseguradora</option>
      </select>
    </div>
    <form @submit.prevent="submitForm">
      <div v-if="selectedOperation === 'modificar' || selectedOperation === 'eliminar'" class="input-group">
        <label :for="`id_${selectedElement}`">ID {{ getElementName }}:</label>
        <select :id="`id_${selectedElement}`" v-model="formData[`id_${selectedElement}`]" required>
          <option v-for="id in getIds()" :key="id" :value="id">{{ id }}</option>
        </select>
      </div>
      <template v-if="selectedOperation !== 'eliminar'">
        <div v-if="selectedElement === 'pais' && selectedOperation === 'insertar'" class="input-group">
          <label for="nombre_pais">Nombre País:</label>
          <input id="nombre_pais" v-model="formData.nombre_pais" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="nombre_agencia_seguro">Nombre Agencia:</label>
          <input id="nombre_agencia_seguro" v-model="formData.nombre_agencia_seguro" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="direccion_postal">Dirección Postal:</label>
          <input id="direccion_postal" v-model="formData.direccion_postal" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="telefono">Teléfono:</label>
          <input id="telefono" v-model="formData.telefono" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="correo_electronico">Correo Electrónico:</label>
          <input id="correo_electronico" v-model="formData.correo_electronico" type="email" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="nombre_director_general">Nombre Director General:</label>
          <input id="nombre_director_general" v-model="formData.nombre_director_general" required>
        </div>
        <div v-if="selectedElement === 'agencia'" class="input-group">
          <label for="nombre_jefe_departamento_seguros">Nombre Jefe Departamento Seguros:</label>
          <input id="nombre_jefe_departamento_seguros" v-model="formData.nombre_jefe_departamento_seguros" required>
        </div>
        <div v-if="selectedElement === 'reclamacion'" class="input-group">
          <label for="numero_poliza">Número Póliza:</label>
          <input id="numero_poliza" v-model="formData.numero_poliza" required>
        </div>
        <div v-if="selectedElement === 'reclamacion'" class="input-group">
          <label for="id_estado_reclamacion">Estado Reclamación:</label>
          <select id="id_estado_reclamacion" v-model="formData.id_estado_reclamacion" required>
            <option value="1">Pendiente</option>
            <option value="2">En proceso</option>
            <option value="3">Resuelta</option>
          </select>
        </div>
        <div v-if="selectedElement === 'reclamacion'" class="input-group">
          <label for="id_tipo_siniestro">Tipo Siniestro:</label>
          <select id="id_tipo_siniestro" v-model="formData.id_tipo_siniestro" required>
            <option value="1">Accidente</option>
            <option value="2">Robo</option>
            <option value="3">Incendio</option>
          </select>
        </div>
        <div v-if="selectedElement === 'reclamacion'" class="input-group">
          <label for="fecha_siniestro">Fecha Siniestro:</label>
          <input id="fecha_siniestro" v-model="formData.fecha_siniestro" type="date" required>
        </div>
        <div v-if="selectedElement === 'reclamacion'" class="input-group">
          <label for="monto_reclamado">Monto Reclamado:</label>
          <input id="monto_reclamado" v-model="formData.monto_reclamado" type="number" step="0.01" required>
        </div>
        <div v-if="selectedElement === 'reaseguradora'" class="input-group">
          <label for="id_pais">País:</label>
          <select id="id_pais" v-model="formData.id_pais" required>
            <option v-for="pais in paises" :key="pais.id" :value="pais.id">{{ pais.nombre }}</option>
          </select>
        </div>
        <div v-if="selectedElement === 'reaseguradora'" class="input-group">
          <label for="id_tipo_reaseguro">Tipo Reaseguro:</label>
          <select id="id_tipo_reaseguro" v-model="formData.id_tipo_reaseguro" required>
            <option value="1">Proporcional</option>
            <option value="2">No proporcional</option>
          </select>
        </div>
        <div v-if="selectedElement === 'reaseguradora' && selectedOperation === 'insertar'" class="input-group">
          <label for="nombre_compannia_reaseguradora">Nombre Compañía Reaseguradora:</label>
          <input id="nombre_compannia_reaseguradora" v-model="formData.nombre_compannia_reaseguradora" required>
        </div>
      </template>
      <button type="submit">{{ getButtonText }}</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      selectedOperation: 'insertar',
      selectedElement: 'pais',
      formData: {},
      paises: [
        { id: 1, nombre: 'España' },
        { id: 2, nombre: 'Francia' },
        { id: 3, nombre: 'Alemania' },
      ],
    }
  },
  computed: {
    getElementName() {
      const names = {
        pais: 'País',
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
      // This method should be implemented to fetch the actual IDs from your data source
      return [1, 2, 3, 4, 5]
    },
    async submitForm() {
      try {
        let response;
        const id = this.formData[`id_${this.selectedElement}`];

        switch (this.selectedElement) {
          case 'pais':
            if (this.selectedOperation === 'insertar') {
              response = await axios.post('/insertPais', this.formData);
            } else if (this.selectedOperation === 'modificar') {
              response = await axios.put(`/updPais/${id}`, this.formData);
            } else if (this.selectedOperation === 'eliminar') {
              response = await axios.delete(`/delPais/${id}`);
            }
            break;
          case 'agencia':
            if (this.selectedOperation === 'insertar') {
              response = await axios.post('/insertAgencia', this.formData);
            } else if (this.selectedOperation === 'modificar') {
              response = await axios.put(`/updAgencia/${id}`, this.formData);
            } else if (this.selectedOperation === 'eliminar') {
              response = await axios.delete(`/delAgencia/${id}`);
            }
            break;
          case 'reclamacion':
            if (this.selectedOperation === 'insertar') {
              response = await axios.post('/insertReclamacion', this.formData);
            } else if (this.selectedOperation === 'modificar') {
              response = await axios.put(`/updReclamacion/${id}`, this.formData);
            } else if (this.selectedOperation === 'eliminar') {
              response = await axios.delete(`/delReclamacion/${id}`);
            }
            break;
          case 'reaseguradora':
            if (this.selectedOperation === 'insertar') {
              response = await axios.post('/insertReaseguradora', this.formData);
            } else if (this.selectedOperation === 'modificar') {
              response = await axios.put(`/updReaseguradora/${id}`, this.formData);
            } else if (this.selectedOperation === 'eliminar') {
              response = await axios.delete(`/delReaseguradora/${id}`);
            }
            break;
        }

        console.log('Respuesta del servidor:', response.data);
        alert('Operación realizada con éxito');
        this.resetForm();
      } catch (error) {
        console.error('Error al realizar la operación:', error);
        alert('Error al realizar la operación');
      }
    }
  }
}
</script>

<style scoped>
.form-container {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

h2 {
  text-align: center;
  color: #333;
  margin-bottom: 20px;
}

.input-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 5px;
  color: #666;
}

input, select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

button {
  width: 100%;
  padding: 10px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:hover {
  background-color: #45a049;
}

@media (max-width: 600px) {
  .form-container {
    max-width: 100%;
    padding: 10px;
  }
}
</style>