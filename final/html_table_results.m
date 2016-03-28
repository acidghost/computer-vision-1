function [ html_table ] = html_table_results( predicted, total_train, nlabels )
%HTML_TABLE_RESULTS Buid html table body to show classification results

html_table = '<tbody>';
for i = 1:total_train
    p_line = '<tr>';
    for j = 1:nlabels
        p_line = strcat(p_line, '<td><img src="', predicted{j}(i).impath, '" /></td>');
    end
    p_line = strcat(p_line, '</tr>');
    html_table = strcat(html_table, p_line);
end
html_table = strcat(html_table, '</tbody>');


end

