document.addEventListener('DOMContentLoaded', () => {
    buttonStates();
    update();
    editAndAddStudent();
    editGit();
    editContacts();
    deleteStudents();
})

function buttonStates() {
    const checkboxes = document.querySelectorAll('.student-checkbox');
    const editBtn = document.getElementById('edit-btn');
    const editGitBtn = document.getElementById('edit-git-btn');
    const editContactBtn = document.getElementById('edit-contact-btn');
    const deleteBtn = document.getElementById('delete-btn');

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
}

function update() {
    const updateBtn = document.getElementById('update-btn');
    updateBtn.addEventListener("click", () => {
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
}

function editAndAddStudent() {
    const addBtn = document.getElementById('add-btn');
    const editBtn = document.getElementById('edit-btn');
    const modal = document.getElementById('student-modal');
    const saveButton = document.getElementById('save-button');
    const firstName = document.getElementById('first_name');
    const name = document.getElementById('name');
    const patronymic = document.getElementById('patronymic');
    const birthdate = document.getElementById('birthdate');

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
    });

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
    
        })
        .catch(error => console.error('Ошибка при загрузке данных студента:', error));
    });
}

function editGit() {
    const editGitModal = document.getElementById('edit-git-modal');
    const gitValueInput = document.getElementById('git-value');
    const saveGitButton = document.getElementById('save-git-button');
    const editGitBtn = document.getElementById('edit-git-btn');

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
}

function editContacts() {
    const editContactModal = document.getElementById('edit-contact-modal');
    const telegramValueInput = document.getElementById('telegram-value');
    const emailValueInput = document.getElementById('email-value');
    const phoneValueInput = document.getElementById('phone-value');
    const saveContactButton = document.getElementById('save-contact-button');
    const editContactBtn = document.getElementById('edit-contact-btn');

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
}

function deleteStudents() {
    const deleteBtn = document.getElementById('delete-btn');
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
    });
}