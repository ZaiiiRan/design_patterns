
  function toggleSortDirection(column) {
    const currentDirection = new URLSearchParams(window.location.search).get('sort_direction');
    return (currentDirection === 'asc' || currentDirection === null) && column === new URLSearchParams(window.location.search).get('sort_column') ? 'desc' : 'asc';
  }

  function toggleTextField(selectId, textFieldId) {
    const selectElement = document.getElementById(selectId);
    const textField = document.getElementById(textFieldId);
    if (selectElement.value === 'yes') {
      textField.disabled = false;
    } else {
      textField.disabled = true;
    }
  }

  document.getElementById('git-select').addEventListener('change', function() {
    toggleTextField('git-select', 'git-text-field');
  });
  document.getElementById('email-select').addEventListener('change', function() {
    toggleTextField('email-select', 'email-text-field');
  });
  document.getElementById('phone-select').addEventListener('change', function() {
    toggleTextField('phone-select', 'phone-text-field');
  });
  document.getElementById('telegram-select').addEventListener('change', function() {
    toggleTextField('telegram-select', 'telegram-text-field');
  });

  toggleTextField('git-select', 'git-text-field');
  toggleTextField('email-select', 'email-text-field');
  toggleTextField('phone-select', 'phone-text-field');
  toggleTextField('telegram-select', 'telegram-text-field');

  function toggleSortDirection(column) {
    const urlParams = new URLSearchParams(window.location.search);
    const currentSortColumn = urlParams.get('sort_column');
    const currentSortDirection = urlParams.get('sort_order');

    if (currentSortColumn === column) {
      urlParams.set('sort_order', currentSortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      urlParams.set('sort_column', column);
      urlParams.set('sort_order', 'asc');
    }

    window.location.search = urlParams.toString();
  }

  document.querySelectorAll('.sortable').forEach(element => {
    element.addEventListener('click', function(event) {
      event.preventDefault();
      toggleSortDirection(this.dataset.column);
    });
  });

  document.getElementById('update-btn').addEventListener('click', function() {
    const filters = ['git', 'email', 'phone', 'telegram'];
    const url = new URL(window.location.href);

    filters.forEach(filter => {
        const selectElement = document.querySelector(`#${filter}-select`);
        const textField = document.querySelector(`#${filter}-text-field`);

        if (selectElement && selectElement.value === 'yes') {
            url.searchParams.set(filter, 'yes');
            url.searchParams.set(`${filter}_value`, textField ? textField.value : '');
        } else if (selectElement && selectElement.value === 'no') {
            url.searchParams.set(filter, 'no');
            url.searchParams.delete(`${filter}_value`);
        } else {
            url.searchParams.delete(filter);
            url.searchParams.delete(`${filter}_value`);
        }
    });

    const fullNameFilter = document.querySelector('#full_name').value
    if (fullNameFilter === '') {
      url.searchParams.delete('full_name')
    } else {
      url.searchParams.set('full_name', fullNameFilter)
    }

    const sortColumn = new URLSearchParams(window.location.search).get('sort_column');
    const sortOrder = new URLSearchParams(window.location.search).get('sort_order');
    const page = 1;

    url.searchParams.set('sort_column', sortColumn || 'id');
    url.searchParams.set('sort_order', sortOrder || 'asc');
    url.searchParams.set('page', page);

    window.location.href = url.toString();
  });

  document.addEventListener('DOMContentLoaded', () => {
    const checkboxes = document.querySelectorAll('.student-checkbox');
    const addBtn = document.getElementById('add-btn');
    const editBtn = document.getElementById('edit-btn');
    const editGitBtn = document.getElementById('edit-git-btn');
    const editContactBtn = document.getElementById('edit-contact-btn');
    const deleteBtn = document.getElementById('delete-btn');

    const modal = document.getElementById('student-modal');
    const form = document.getElementById('student-form');
    const saveButton = document.getElementById('save-button');
    const firstName = document.getElementById('first_name');
    const name = document.getElementById('name');
    const patronymic = document.getElementById('patronymic');
    const birthdate = document.getElementById('birthdate');

    function validateForm() {
      const isValid = firstName.value && name.value && patronymic.value && birthdate.value;
      saveButton.disabled = !isValid;
    }

    form.addEventListener('input', validateForm);

    saveButton.addEventListener('click', () => {
  const studentData = {
    first_name: firstName.value,
    name: name.value,
    patronymic: patronymic.value,
    birthdate: birthdate.value,
  };

  const action = modal.dataset.action === 'edit' ? 'update' : 'create';
  const url = action === 'create' ? '/students' : `/students/${modal.dataset.studentId}`;

  fetch(url, {
    method: action === 'create' ? 'POST' : 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
    },
    body: JSON.stringify({ student: studentData }),
  })
    .then(response => {
      if (!response.ok) {
        return response.json().then(data => Promise.reject(data));
      }
      return response.json();
    })
    .then(data => {
      window.location.reload();
    })
    .catch(error => {
      if (error.errors) {
        alert('Ошибки:\n' + JSON.stringify(error.errors));
      } else {
        alert('Произошла ошибка');
      }
    });
});

  addBtn.addEventListener('click', () => {
    modal.dataset.action = 'create';
      firstName.value = '';
      name.value = '';
      patronymic.value = '';
      birthdate.value = '';
  })

  editBtn.addEventListener('click', () => {
  const selectedCheckbox = document.querySelector('.student-checkbox:checked');
  const studentId = selectedCheckbox.dataset.id;

  modal.dataset.action = 'edit';
  modal.dataset.studentId = studentId;

  fetch(`/students/${studentId}`, {
    method: 'GET',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
    },
  })
    .then(response => response.json())
    .then(data => {
      firstName.value = data.first_name;
      name.value = data.name;
      patronymic.value = data.patronymic;
      birthdate.value = data.birthdate;

      validateForm();
    })
    .catch(error => console.error('Ошибка при загрузке данных студента:', error));
});

    const editGitModal = document.getElementById('edit-git-modal');
    const gitValueInput = document.getElementById('git-value');
    const saveGitButton = document.getElementById('save-git-button');

    editGitBtn.addEventListener('click', () => {
      const selectedCheckbox = document.querySelector('.student-checkbox:checked');
      if (!selectedCheckbox) {
        alert('Выберите студента для редактирования Git!');
        return;
      }
      
      const studentId = selectedCheckbox.dataset.id;
      editGitModal.dataset.studentId = studentId;

      fetch(`/students/${studentId}`, {
        method: 'GET',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      })
        .then(response => response.json())
        .then(data => {
          gitValueInput.value = data.git || '';
        })
        .catch(error => console.error('Ошибка при загрузке данных Git:', error));
    });

    saveGitButton.addEventListener('click', () => {
      const studentId = editGitModal.dataset.studentId;
      const gitValue = gitValueInput.value;

      fetch(`/students/${studentId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ student: { git: gitValue } }),
      })
      .then(response => {
      if (!response.ok) {
        return response.json().then(data => Promise.reject(data));
      }
      return response.json();
    })
    .then(data => {
      window.location.reload();
    })
    .catch(error => {
      if (error.errors) {
        alert('Ошибки:\n' + JSON.stringify(error.errors));
      } else {
        alert('Произошла ошибка');
      }
    });
    });

    const editContactModal = document.getElementById('edit-contact-modal');
    const telegramValueInput = document.getElementById('telegram-value');
    const emailValueInput = document.getElementById('email-value');
    const phoneValueInput = document.getElementById('phone-value');
    const saveContactButton = document.getElementById('save-contact-button');

    editContactBtn.addEventListener('click', () => {
      const selectedCheckbox = document.querySelector('.student-checkbox:checked');
      if (!selectedCheckbox) {
        alert('Выберите студента для редактирования контактов!');
        return;
      }
      
      const studentId = selectedCheckbox.dataset.id;
      editContactModal.dataset.studentId = studentId;

      fetch(`/students/${studentId}`, {
        method: 'GET',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      })
        .then(response => response.json())
        .then(data => {
          telegramValueInput.value = data.telegram || '';
          emailValueInput.value = data.email || '',
          phoneValueInput.value = data.phone_number || '',
          gitValueInput.value = data.git || '';
        })
        .catch(error => console.error('Ошибка при загрузке данных:', error));
    });

    saveContactButton.addEventListener('click', () => {
      const studentId = editContactModal.dataset.studentId;
      const telegramValue = telegramValueInput.value;
      const emailValue = emailValueInput.value;
      const phoneValue = phoneValueInput.value;

      fetch(`/students/${studentId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ student: { telegram: telegramValue, email: emailValue, phone_number: phoneValue } }),
      })
        .then(response => {
      if (!response.ok) {
        return response.json().then(data => Promise.reject(data));
      }
      return response.json();
    })
    .then(data => {
      window.location.reload();
    })
    .catch(error => {
      if (error.errors) {
        alert('Ошибки:\n' + JSON.stringify(error.errors));
      } else {
        alert('Произошла ошибка');
      }
    });
    });

    deleteBtn.addEventListener('click', () => {
      const selectedCheckboxes = document.querySelectorAll('.student-checkbox:checked');
      const selectedStudentIds = Array.from(selectedCheckboxes).map(checkbox => checkbox.dataset.id);

      if (selectedStudentIds.length === 0) {
        alert('Выберите хотя бы одного студента для удаления!');
        return;
      }

      fetch('/students/delete_multiple', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            },
            body: JSON.stringify({ student_ids: selectedStudentIds }),
        })
        .then(response => {
            if (response.ok) {
                window.location.reload();
            } else {
                alert('Ошибка при удалении студентов!');
            }
        })
        .catch(error => console.error('Ошибка:', error));

    })

    function updateButtonStates() {
      const checkedCount = Array.from(checkboxes).filter(checkbox => checkbox.checked).length;

      const isSingleSelection = checkedCount === 1;
      editBtn.disabled = !isSingleSelection;
      editGitBtn.disabled = !isSingleSelection;
      editContactBtn.disabled = !isSingleSelection;

      deleteBtn.disabled = checkedCount === 0;
    }

    checkboxes.forEach(checkbox => {
      checkbox.addEventListener('change', updateButtonStates);
    });

    updateButtonStates();
  });
