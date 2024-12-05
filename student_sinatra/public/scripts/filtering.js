const filtering = () => {
    const sortableColumns = document.querySelectorAll('.sortable-column');

    sortableColumns.forEach(column => {
        column.addEventListener('click', function (event) {
        event.preventDefault();

        const columnIndex = this.dataset.columnIndex;

        fetch('/sort', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ column_index: columnIndex })
        })
        .then(data => {
            location.reload();
        })
        .catch(error => {
            console.error('Ошибка при сортировке:', error);
        });
        });
    });

    function resetFilters() {
        const inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
            if (input.type !== 'hidden') {
                input.value = '';
            }
        });

        const selects = document.querySelectorAll('select');
        selects.forEach(select => {
            select.value = '0'; 
        });
    }

    document.getElementById('reset-filters').addEventListener('click', function(event) {
        event.preventDefault(); 
        resetFilters();
    });
} 