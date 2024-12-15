document.addEventListener('DOMContentLoaded', () => {
    buttonStates();
    update();
    deleteLab();
    editAndAddLab();
});

function update() {
    const updateBtn = document.getElementById('update-btn');
    updateBtn.addEventListener('click', () => {
        window.location.reload();
    });
}

function deleteLab() {
    const deleteBtn = document.getElementById('delete-btn');
    deleteBtn.addEventListener("click", () => {
        const selectedCheckbox = document.querySelector('.lab-checkbox:checked');
        const labId = selectedCheckbox.dataset.id;

        fetch(`/labs/${labId}`, {
            method: "DELETE",
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            },
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

function editAndAddLab() {
    const addBtn = document.getElementById('add-btn');
    const editBtn = document.getElementById('edit-btn');
    const modal = document.getElementById('lab-modal');
    const saveButton = document.getElementById('save-button');
    const name = document.getElementById('name');
    const topics = document.getElementById('topics');
    const tasks = document.getElementById('tasks');
    const dateOfIssue = document.getElementById('date-of-issue');

    addBtn.addEventListener('click', () => {
        modal.dataset.action = 'create';
        name.value = '';
        topics.value = '';
        tasks.value = '';
        dateOfIssue.value = '';
    });

    editBtn.addEventListener('click', () => {
        const selectedCheckbox = document.querySelector('.lab-checkbox:checked');
        const labId = selectedCheckbox.dataset.id;

        modal.dataset.action = "edit";
        modal.dataset.labId = labId;

        fetch(`/labs/${labId}`, {
            method: "GET",
            headers: {
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            },
        })
        .then(response => response.json())
        .then(data => {
            name.value = data.name;
            topics.value = data.topics;
            tasks.value = data.tasks;
            dateOfIssue.value = data.date_of_issue;
        })
        .catch(error => console.error('Ошибка при загрузке данных о лабораторной работе:', error))
    });

    saveButton.addEventListener('click', () => {
        const labData = {
            name: name.value,
            topics: topics.value,
            tasks: tasks.value,
            date_of_issue: dateOfIssue.value,
        };

        const action = modal.dataset.action === 'edit' ? 'update' : 'create';
        const url = action === 'create' ? '/labs' : `/labs/${modal.dataset.labId}`;

        fetch(url, {
            method: action === 'create' ? 'POST' : 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
            },
            body: JSON.stringify({ lab: labData }),
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

function buttonStates() {
    const checkboxes = document.querySelectorAll('.lab-checkbox');
    const editBtn = document.getElementById('edit-btn');
    const deleteBtn = document.getElementById('delete-btn');

    function updateButtonStates() {
        const selectedCheckboxes = Array.from(checkboxes).filter(checkbox => checkbox.checked)
        const checkedCount = selectedCheckboxes.length;

        const isSingleSelection = checkedCount === 1;
        editBtn.disabled = !isSingleSelection;
        deleteBtn.disabled = !isSingleSelection;
        
        if (checkedCount === 1) {
            const lastCheckbox = checkboxes[checkboxes.length - 1];
            deleteBtn.disabled = selectedCheckboxes[0] !== lastCheckbox;
        } else {
            deleteBtn.disabled = true;
        }
    }

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateButtonStates);
    });
    updateButtonStates();
}