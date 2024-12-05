const selectionAndActions = () => {
    const checkboxes = document.querySelectorAll('input[name="selected_rows[]"]');
    const addBtn = document.getElementById('add_btn');
    const editBtn = document.getElementById('edit_btn');
    const deleteBtn = document.getElementById('delete_btn');
    const editGitBtn = document.getElementById('edit_git_btn');
    const editContactsBtn = document.getElementById('edit_contacts_btn');
    const updateBtn = document.getElementById('update_btn');
    const actionsForm = document.getElementById('actions_form');
    const modalContainer = document.createElement('div');
    modalContainer.id = 'modal-container';
    document.body.appendChild(modalContainer);

    checkboxes.forEach(cb => cb.addEventListener('change', function() {
        const selected = Array.from(checkboxes)
        .filter(cb => cb.checked)
        .map(cb => cb.value);

        fetch('/select_rows', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ selected: selected })
        });
        updateButtonStates();
    }));

    function updateButtonStates() {
        const selected = Array.from(checkboxes).filter(cb => cb.checked);
        editBtn.disabled = selected.length !== 1;
        deleteBtn.disabled = selected.length === 0;
        editGitBtn.disabled = selected.length !== 1;
        editContactsBtn.disabled = selected.length !== 1;
    }

    deleteBtn.addEventListener('click', function(event) {
        event.preventDefault();

        fetch('/', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
        })
        .then(response => response.text())
        .then(data => {
            location.reload();
        })
        .catch(error => {
            console.error('Ошибка при удалении данных:', error);
        });
    });

    updateBtn.addEventListener('click', function(event) {
        event.preventDefault()
        const filters = {}
        const filterInputs = document.querySelectorAll('#filters-form input, #filters-form select')

        filterInputs.forEach(function(input) {

        let name = input.name.split('_')[0];
        if (!filters[name]) {
            filters[name] = { };
        }
        if (input.type === 'text') {
            filters[name]["text"] = input.value; 
        } else if (input.tagName.toLowerCase() === 'select' && name != 'name') {
            filters[name]["option"] = input.value; 
        }
        });

        fetch('/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(filters)
        })
        .then(data => {
            location.reload();
        })
        .catch(error => {
            console.error('Ошибка при обновлении фильтров:', error);
        });
    });

    actionsForm.addEventListener('click', function(event) {
        event.preventDefault();
        const action = event.target.value;
        if (!['add_student', 'replace_student', 'edit_contacts', 'edit_git'].includes(action)) return;

        fetch('/modal', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ mode: action })
        })
        .then(response => response.text())
        .then(html => {
            modalContainer.innerHTML = html;

            const modalWindow = document.getElementById('modalWindow');
            const modalOkButton = document.getElementById('modalOkButton');
            const modalCancelButton = document.getElementById('modalCancelButton')
            const modalFields = modalWindow.querySelectorAll('input');

            const bootstrapModal = new bootstrap.Modal(modalWindow);
            modalCancelButton.addEventListener('click', function(event) {
                event.preventDefault()
                bootstrapModal.hide();
            });

            bootstrapModal.show();

            modalFields.forEach(input => {
                input.addEventListener('input', () => { validateModal(modalFields, modalOkButton); });
            });
            modalOkButton.addEventListener('click', () => { modalOk(modalFields, bootstrapModal); });
        });
    });

    function modalOk(modalFields, bootstrapModal) {
        const data = Array.from(modalFields).reduce((acc, field) => {
            acc[field.name] = field.value.trim();
            return acc;
        }, {});

        fetch('/modal_submit', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(errorText => {
                    document.getElementById("modal-error").innerHTML = errorText;
                    throw new Error(errorText);
                });
            }
            return response.text()
        })
        .then(result => {
            bootstrapModal.hide();
            location.reload(); 
        })
        .catch(error => {
            console.error(error);
        });
    }

    function validateModal(modalFields, modalOkButton) {
        const data = Array.from(modalFields).reduce((acc, field) => {
            acc[field.name] = field.value.trim();
            return acc;
        }, {});

        fetch('/validate_modal', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(response => response.json())
        .then(result => {
            modalOkButton.disabled = result.valid !== 0 && !result.valid;
        });
    }
}